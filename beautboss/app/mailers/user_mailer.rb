class UserMailer < ActionMailer::Base
  default sender: ENV['FROM_EMAIL']

  # def signup_confirmation(user)
  #   @user = user
  #   mail to: user.email, subject: "Sign Up Confirmation"
  # end

  def password_reset(user, token)
  	@user = user
  	@token = token
  	mail to: user.email, subject: "Password reset for beautboss app"
  end

end