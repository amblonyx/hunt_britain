class UserMailer < ActionMailer::Base
	default from: "huntbritain@gmail.com"

	def welcome_email(user)
		@user = user
		@url  = signin_path 
		mail(to: user.email, subject: 'Welcome to Hunt Britain')
	end
  
	def feedback_email(name, email, message)
		@name = name
		@email = email
		@message = message
		mail(to: "treasurehuntbritain@gmail.com", subject: 'Feedback from Treasure Hunt Britain')		
	end
end
