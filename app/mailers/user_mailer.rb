class UserMailer < ActionMailer::Base
  default from: "huntbritain@gmail.com"
  
    def welcome_email(user)
    @user = user
    @url  = signin_path 
    mail(to: user.email, subject: 'Welcome to Hunt Britain')
  end
end
