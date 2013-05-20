PAYPAL_ACCOUNT = ENV["PAYPAL_ACCOUNT"]
if Rails.env.production?
	PAYPAL_LINK = "https://www.paypal.com/cgi-bin/webscr?"
	ActiveMerchant::Billing::Base.mode = :production
else
	PAYPAL_LINK = "https://www.sandbox.paypal.com/cgi-bin/webscr?"
	ActiveMerchant::Billing::Base.mode = :test
end