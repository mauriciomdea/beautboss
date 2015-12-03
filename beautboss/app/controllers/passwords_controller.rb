class PasswordsController < ApplicationController

  def new
    @user = User.new
  end

  def create 
    user = User.find_by(email: user_params[:email])
    if user.nil?
      redirect_to forgot_password_url, notice: "Can't find an user with this email address :("
    else
      tmp = TemporaryPassword.create(user: user)
      UserMailer.password_reset(user, tmp.password).deliver_now # sends password to user's email
      render :show
    end
  end

  private

    def user_params
      params.require(:user).permit(:email)
    end

end
