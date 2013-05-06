class UserMailer < ActionMailer::Base
 	add_template_helper(UsersHelper) 
	default from: GMAIL_SMTP_USER

	def welcome_email(user)
		@user = user
		@url  = signin_path 
		#if Rails.env.development? 
			mail(to: GMAIL_TEST_RECIPIENT, bcc: GMAIL_SMTP_USER, subject: 'Welcome to Hunt Britain')		
		#else
		#	mail(to: user.email, bcc: GMAIL_SMTP_USER, subject: 'Welcome to Hunt Britain')
		#end 
	end
  
	def confirm_purchase(purchase)
		@purchase = purchase		
		
		#if Rails.env.development? 
			mail(to: GMAIL_TEST_RECIPIENT, bcc: GMAIL_SMTP_USER, subject: 'Thanks for your order')	
		#else
		#	mail(to: purchase.user.email, bcc: GMAIL_SMTP_USER, subject: 'Thanks for your order')	
		#end 

	end
	
	def deliver_purchases(purchase)
		@purchase = purchase
		@purchase.purchase_items.each do |item|
			if item.product.format == "Download"
				file_name = item.product.data_file
				#attachments[file_name] = File.read("#{DOWNLOAD_PATH}#{file_name}")
				#attachments[file_name] = {data: File.read("#{DOWNLOAD_PATH}#{file_name}"), :mime_type => 'application/pdf' }
				#attachment content_type: 'application/pdf', body: File.read("#{DOWNLOAD_PATH}#{file_name}"), filename: file_name, transfer_encoding: "base64" 
				attachments[file_name] = File.read("#{DOWNLOAD_PATH}#{file_name}", mode: "rb")
			end 
		end

		#if Rails.env.development? 
			mail(to: GMAIL_TEST_RECIPIENT, bcc: GMAIL_SMTP_USER, subject: 'Your Treasure Hunt')	
		#else
		#	mail(to: purchase.user.email, bcc: GMAIL_SMTP_USER, subject: 'Your Treasure Hunt')	
		#end 
	end

	def feedback_email(name, email, message)
		@name = name
		@email = email
		@message = message
		mail(to: GMAIL_SMTP_USER, subject: 'Feedback from Treasure Hunt Britain')		
	end

	def problem_email(hunt, clue, problem)
		@hunt = hunt
		@clue = clue
		@problem = problem
		mail(to: GMAIL_SMTP_USER, subject: 'Feedback about a hunt')		
	end

	def reset_password(user)
		@user = user
		#if Rails.env.development? 
			mail(to: GMAIL_TEST_RECIPIENT, bcc: GMAIL_SMTP_USER, subject: 'You requested a new Treasure Hunt Britain password')		
		#else
		#	mail(to: user.email, bcc: GMAIL_SMTP_USER, subject: 'Welcome to Hunt Britain')
		#end 

	end 
end
