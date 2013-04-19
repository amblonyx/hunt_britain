class Hunt < ActiveRecord::Base

	require 'nokogiri'

	attr_accessible :completed, :current_clue, :current_status, :email, :last_submitted, 
		:paused, :product_id, :user_id, :started, :started_at, :team_name, :time_taken, :voucher_code
  
	belongs_to :product
	belongs_to :user

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

	def start
		self.started = true
		self.started_at = Time.now
		self.current_clue = 1
		self.current_status = "Fresh"
		
		self.paused = false
		self.completed = false
		self.time_taken = 0
		self.last_submitted = self.started_at # so the time_taken can be easily updated			
	end
	def add_penalty(minutes)
		self.time_taken = self.time_taken + (minutes * 60)
	end
	def mark_time
		thetime = Time.now
		self.time_taken = self.time_taken + thetime.to_i - self.last_submitted.to_i
		self.last_submitted = thetime 			
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
		add_penalty 5	# giving up carried a 5 minute penalty
	end
	def pause_hunt
		self.paused = true
		mark_time
		add_penalty 2	# to stop people pausing while walking between clues
	end
	def resume_hunt
		self.paused = false
		self.last_submitted = Time.now	# so the paused period is skipped by time_taken			
	end
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
	
	private
	
	def load_xml
	end

end