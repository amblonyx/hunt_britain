class Hunt < ActiveRecord::Base
	include StandardLib
	require 'nokogiri'

	attr_accessible :completed, :current_clue, :current_status, :email, :last_submitted, 
		:paused, :product_id, :user_id, :started, :started_at, :team_name, :time_taken, 
		:voucher_code, :hunter_token, :hunt_group
  
	belongs_to :product
	belongs_to :user
	belongs_to :purchase_item

	before_save :create_voucher_code
	scope :none, where("1 = 0")

	def generate_hunt_group
		self.hunt_group = loop do
		  random_token = SecureRandom.urlsafe_base64
		  break random_token unless Hunt.where(hunt_group: random_token).exists?
		end
	end
  
	def status 
		if !self.started?
			"Fresh"
		elsif self.completed?
			"Completed"
		elsif self.started? && !self.completed?
			"Ongoing"
		end 
	end 
	
	def self.filtered( opts = {}, sort = {} )
		fields = Array.new
		criteria = Hash.new
		status = Array.new
		with_user = false 

		if opts.has_key?(:product)
			if !opts[:product].empty?
				fields.push("products.name ilike :product")
				criteria[:product] = "%#{opts[:product]}%"
			end 
		end
		if opts.has_key?(:hunt_group)
			if !opts[:hunt_group].empty?
				fields.push("hunt_group ilike :hunt_group")
				criteria[:hunt_group] = "%#{opts[:hunt_group]}%"
			end
		end
		if opts.has_key?(:voucher_code)
			if !opts[:voucher_code].empty?
				fields.push("voucher_code ilike :voucher_code")
				criteria[:voucher_code] = "%#{opts[:voucher_code]}%"
			end
		end
		
		if opts.has_key?(:status_fresh)
			if opts[:status_fresh].to_s == "1"
				status.push("(started = false)")
			end 
		end
		if opts.has_key?(:status_on_going)
			if opts[:status_on_going].to_s == "1"
				status.push("(started = true AND completed = false)")
			end
		end
		if opts.has_key?(:status_paused)
			if opts[:status_paused].to_s == "1"
				status.push("(paused = true)")
			end
		end
		if opts.has_key?(:status_completed)
			if opts[:status_completed].to_s == "1"
				status.push("(completed = true)")
			end
		end
		if opts.has_key?(:user)
			if !opts[:user].empty?
				fields.push("users.email ilike :user")
				criteria[:user] = "%#{opts[:user]}%"
				with_user = true 
			end
		end

		status_string = status.join(" OR ")
		if !status_string.empty?
			fields.push("(#{status_string})")
		end
		field_string = fields.join(" AND ")
		
		if with_user
			result = self.joins(:product).joins(:user).where( field_string, criteria ).order( "#{sort[:field]} #{sort[:dir]}" )
		else
			result = self.joins(:product).where( field_string, criteria ).order( "#{sort[:field]} #{sort[:dir]}" )		
		end
		
		return result
	end
	
	def start
	
		self.started = true
		self.current_clue = 1
		self.current_status = "Fresh"		
		self.paused = false
		self.completed = false

		self.last_submitted = Time.now
		self.started_at = self.last_submitted if self.started_at.nil?	# restarts leave started_at
		self.time_taken = 0 if self.time_taken.nil?	# restarts shouldn't set back to zero
		
		self.save
		
	end
	
	def restart
	
		self.started = false
		self.paused = false
		self.completed = false

		self.current_clue = nil
		self.current_status = nil
		self.last_submitted = nil		
		
		# we leave started_at and time_taken as they were, so people can't cheat
		
	end
	
	def add_penalty(minutes)
		self.time_taken = self.time_taken + (minutes * 60)
	end
	
	def mark_time
		thetime = Time.now
		thediff = thetime.to_i - self.last_submitted.to_i
		if thediff > 1800	# after 30 minutes we assume they've lost connection or meant to pause
			thediff = 1800
		end
		self.time_taken = self.time_taken + thediff
		self.last_submitted = thetime 			
	end
	
	def take_hint
		add_penalty 2
		self.save
	end

	def right_answer
		mark_time
		next_clue
		self.save
	end
	
	def wrong_answer
		add_penalty 2		# 2 minutes for a wrong answer
		self.save
	end
	
	def next_clue
		self.current_clue = self.current_clue + 1
		f = File.open( XML_PATH + "products/#{self.product.data_file}.xml" )
		huntxml = Nokogiri::XML(f)
		f.close
		if self.current_clue > huntxml.xpath("//number_of_clues").inner_text.to_i
			self.completed = true
		end
	end
	
	def pass_on_clue
		self.current_status = "Passed"
		next_clue
		mark_time
		add_penalty 8	# giving up carried an 8 minute penalty
		self.save
	end

	def pause_hunt
		self.paused = true
		mark_time
		add_penalty 2	# to stop people pausing while walking between clues
		self.save
	end
	
	def resume_hunt
		self.paused = false
		self.last_submitted = Time.now	# so the paused period is skipped by time_taken			
		self.save
	end

	# this isn't used currently, because the answer is passed as part of a param key
	def check_answer(suggested)
		f = File.open( XML_PATH + "products/#{self.product.data_file}.xml" )
		huntxml = Nokogiri::XML(f)
		f.close
		clue_node = huntxml.xpath("//clues/clue[@number='#{self.current_clue}']")
		if suggested == clue_node.xpath("answer").first.get_attribute("id")
			self.mark_time
			self.next_clue
			return true
		else
			return false
		end
	end
	
	def create_voucher_code(force = false)
		if self.voucher_code.blank? || force  
			self.voucher_code = loop do
			  random_token = random_alphabet(6)
			  break random_token unless Hunt.where(voucher_code: random_token).exists?
			end
		end
	end

end

# == Schema Information
#
# Table name: hunts
#
#  id             :integer         not null, primary key
#  product_id     :integer
#  voucher_code   :string(255)
#  team_name      :string(255)
#  email          :string(255)
#  started        :boolean
#  paused         :boolean
#  completed      :boolean
#  started_at     :datetime
#  last_submitted :datetime
#  current_clue   :integer
#  current_status :string(255)
#  time_taken     :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  user_id        :integer
#

