if Rails.env.production?
	PAYPAL_ACCOUNT = 'huntbritain@amblonyx.com'
	ActiveMerchant::Billing::Base.mode = :test
else
	PAYPAL_ACCOUNT = 'huntbritain@amblonyx.com'
	ActiveMerchant::Billing::Base.mode = :test
end