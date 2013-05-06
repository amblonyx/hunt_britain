if Rails.env.production?
	PAYPAL_ACCOUNT = ENV["PAYPAL_ACCOUNT"]
	ActiveMerchant::Billing::Base.mode = :test
else
	PAYPAL_ACCOUNT = ENV["PAYPAL_ACCOUNT"]
	ActiveMerchant::Billing::Base.mode = :test
end