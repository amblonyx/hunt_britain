class User < ActiveRecord::Base
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
	attr_accessible :email, :name, :password, :password_confirmation, 
					:address_1, :address_2, :town, :county, :postcode, :country, :phone
	has_secure_password
	has_many :hunts
	
	before_save do |user| 
		user.email = email.downcase 
		if user.guest?
			user.user_name = SecureRandom.hex(10)
		else
			user.user_name = email
		end
	end
	before_save :create_remember_token
  
	validates :name, presence: true, length: {maximum: 50},
				unless: :guest?  
	validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}
	validates :password, presence: true, length: {minimum: 6}, 
				if: :password_digest_changed?,
				unless: :guest?  
	validates :password_confirmation, presence: true, 
				if: :password_digest_changed?,
				unless: :guest?  

	private
	
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
#

