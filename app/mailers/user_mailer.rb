class UserMailer < ActionMailer::Base
 	add_template_helper(UsersHelper) 
	default from: GMAIL_SMTP_USER

	def welcome_email(user)
		@user = user
		@url  = signin_path 
		if Rails.env.production? 
			mail(to: user.email, bcc: GMAIL_SMTP_USER, subject: 'Welcome to Hunt Britain')
		else
			mail(to: GMAIL_TEST_RECIPIENT, bcc: GMAIL_SMTP_USER, subject: 'Welcome to Hunt Britain')		
		end 
	end
  
	def confirm_purchase(purchase)
		@purchase = purchase		
		
		if Rails.env.production? 
			mail(to: purchase.user.email, bcc: GMAIL_SMTP_USER, subject: 'Thanks for your order')	
		else
			mail(to: GMAIL_TEST_RECIPIENT, bcc: GMAIL_SMTP_USER, subject: 'Thanks for your order')	
		end 

	end
	
	def deliver_purchases(purchase)
		@deliver = true
		@problem = Array.new
		
		@purchase = purchase
		@purchase.purchase_items.each do |item|
			if item.product.format == "Download" 
				file_name = item.product.data_file
				file_name_2 = item.product.data_file_2
			elsif item.product.format == "Online" 
				# for Online hunts, send PDF and cheat sheets anyway 		
				# Find associated download Product, and use its data files
				product_code = item.product.product_code[0, item.product.product_code.length-1] + "D"
				download_product = Product.find_by_product_code(product_code)
				file_name = download_product.data_file
				file_name_2 = download_product.data_file_2
			end 
			
			file_path = "#{DOWNLOAD_PATH}#{file_name}"
			file_path_2 = "#{DOWNLOAD_PATH}#{file_name_2}"
			
			if File.exist?(file_path)
				attachments[file_name] = File.read(file_path, mode: "rb")
				
				if File.exist?(file_path_2)
					attachments[file_name_2] = File.read(file_path_2, mode: "rb")
				end
			else
				@deliver = false 
				@problem.push(file_path)
			end 
		end

		if @problem.any? 
			mail(to: GMAIL_SMTP_USER, subject: 'PROBLEM trying to deliver purchases')	
		else
			if Rails.env.production? 
				mail(to: purchase.user.email, bcc: GMAIL_SMTP_USER, subject: 'Your Treasure Hunt')	
			else
				mail(to: GMAIL_TEST_RECIPIENT, bcc: GMAIL_SMTP_USER, subject: 'Your Treasure Hunt')	
			end 			
		end 
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
		if Rails.env.production? 
			mail(to: user.email, subject: 'You requested a new Treasure Hunt Britain password')
		else
			mail(to: GMAIL_TEST_RECIPIENT, subject: 'You requested a new Treasure Hunt Britain password')		
		end 

	end 
end
