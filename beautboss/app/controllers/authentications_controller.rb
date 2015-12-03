class AuthenticationsController < ApplicationController

  def index
    @user = User.new
  end

  def create
    puts user_params[:email]
    if @user = User.find_by(email: user_params[:email])
      if @user.try(:authenticate, user_params[:password])
        session[:user_id] = @user.id
        redirect_to newsfeeds_path, notice: "Logged in!"
      else
        _not_authorized "Your username or password does not match"
      end
    else
      _not_authorized "Your username or password does not match"
    end
  end

  def password_reset
  end

  def destroy
  end

  private

    def user_params
      params.require(:user).permit(:name, :username, :email, :password, :avatar, :website, :location, :bio)
    end

end
