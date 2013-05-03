class User < ActiveRecord::Base
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
	attr_accessible :user_name, :email, :name, :password, :password_confirmation, 
					:address_1, :address_2, :town, :county, :postcode, :country, :phone
	has_secure_password
	has_many :hunts
	has_many :purchases
	
	before_save do |user| 
		if !user.guest?
			user.email = user.user_name
		else
			user.user_name = SecureRandom.hex(10)
			user.password = "password"
			user.remember_token = "guest"
		end
		user.email = user.email.downcase 
	end
	before_save :create_remember_token
	
 	validates :user_name, presence: true, uniqueness: true
	
	validates :postcode, presence: true, if: :have_address?
	validates :address_1, presence: true, if: :have_postcode?
	
	with_options if: :guest? do |user|
		user.validates :email, presence: true, format: {with: VALID_EMAIL_REGEX} 
	end
	
	with_options if: :not_guest? do |user|
		user.validates :name, presence: true, length: {maximum: 50}
		user.validates :user_name, format: {with: VALID_EMAIL_REGEX} 
		user.validates :password, 
						presence: true, 
						confirmation: true,
						length: { within: 6..40 }, 
						on: :create
	end
	
	#validates :name, presence: true, length: {maximum: 50},
	#			unless: :guest?  
				
	#validates :user_name, 
	#				presence: true, 
	#				uniqueness: true,
	#				format: {with: VALID_EMAIL_REGEX},
	#				if: :is_guest?
				
	#validates :email, 
	#				presence: true, 
	#				format: {with: VALID_EMAIL_REGEX} 

					
				#if: :password_digest_changed?,
	#validates :password_confirmation, presence: true, 
	#			if: :password_digest_changed?,
	#			unless: :guest?  

	def create_as_guest(id)
		self.email = id
		self.user_name = SecureRandom.hex(10)
		self.password = "password"
		self.guest = true 	
		self.remember_token = "guest"
	end 
	
	def is_valid_email?(email)
		(email =~ VALID_EMAIL_REGEX)
	end

	def have_address?
		!self.address_1.blank?
	end
	
	def has_voucher?(voucher)
		hunts.find_by_voucher_code(voucher)
	end
	
	private
	def not_guest?
		!self.guest?
	end
	def have_postcode?
		!self.postcode.blank?
	end
	def create_remember_token 
		self.remember_token = SecureRandom.urlsafe_base64
	end
end

# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#  address_1       :string(255)
#  address_2       :string(255)
#  town            :string(255)
#  county          :string(255)
#  postcode        :string(255)
#  country         :string(255)
#  phone           :string(255)
#  user_name       :string(255)
#  guest           :boolean         default(FALSE)
#

