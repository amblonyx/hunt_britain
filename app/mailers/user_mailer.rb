class UserMailer < ActionMailer::Base
 	add_template_helper(UsersHelper) 
	default from: "treasurehuntbritain@gmail.com"

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

	def problem_email(hunt, clue, problem)
		@hunt = hunt
		@clue = clue
		@problem = problem
		mail(to: "treasurehuntbritain@gmail.com", subject: 'Feedback about a hunt')		
	end

	def confirm_purchase(purchase)
		@purchase = purchase
		mail(to: purchase.user.email, subject: 'Thanks for your order')		
	end


end
