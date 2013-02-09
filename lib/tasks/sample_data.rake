namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		make_users
	end
	
	def make_users
		# Create an admin user
		admin = User.create!(	name: "Mara mara",
						email: "mara@amblonyx.com",
						password: "password",
						password_confirmation: "password")
		admin.toggle!(:admin)
		
		# Create 99 other users (non-admin)
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@amblonyx.org"
			password = "password"
			User.create!(	name: name,
							email: email,
							password: password,
							password_confirmation: password)
		end
	end
end