class UserMailer < ActionMailer::Base

  # default from: ENV['FROM_EMAIL']

  # def signup_confirmation(user)
  #   @user = user
  #   mail to: user.email, subject: "Sign Up Confirmation"
  # end

  def password_reset(user, pwd)
  	@user = user
  	@password = pwd
  	mail  to: user.email, 
          subject: "Password reset for beautboss app",
          from: ENV['FROM_EMAIL']
  end

end