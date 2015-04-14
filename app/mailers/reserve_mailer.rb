class ReserveMailer < ActionMailer::Base
  default from: "contact@gogopark.co"
 
  def reserve_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
end
