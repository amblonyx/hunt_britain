if Rails.env.production?
	PAYPAL_ACCOUNT = 'shortclaws@gmail.com'
else
	PAYPAL_ACCOUNT = 'shortclaws@gmail.com'
	ActiveMerchant::Billing::Base.mode = :test
end