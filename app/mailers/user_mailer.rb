class UserMailer < ActionMailer::Base
 	add_template_helper(UsersHelper) 
	default from: "treasurehuntbritain@gmail.com"

	def welcome_email(user)
		@user = user
		@url  = signin_path 
		#-- mail(to: user.email, bcc: "treasurehuntbritain@gmail.com", subject: 'Welcome to Hunt Britain')
		
		#DEVELOPMENT: In case we inadvertantly send out emails to unknown email addresses
		mail(to: "shortclaws@gmail.com", bcc: "treasurehuntbritain@gmail.com", subject: 'Welcome to Hunt Britain')		
	end
  
	def confirm_purchase(purchase)
		@purchase = purchase		
		#-- mail(to: purchase.user.email, bcc: "treasurehuntbritain@gmail.com", subject: 'Thanks for your order')		
		
		#DEVELOPMENT: In case we inadvertantly send out emails to unknown email addresses
		mail(to: "shortclaws@gmail.com", bcc: "treasurehuntbritain@gmail.com", subject: 'Thanks for your order')	
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
		#-- mail(to: purchase.user.email, bcc: "treasurehuntbritain@gmail.com", subject: 'Your Treasure Hunt')		

		#DEVELOPMENT: In case we inadvertantly send out emails to unknown email addresses
		mail(to: "shortclaws@gmail.com", bcc: "treasurehuntbritain@gmail.com", subject: 'Your Treasure Hunt')		
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


end
