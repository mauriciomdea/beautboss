class AuthenticationsController < ApplicationController

  def index
    @user = User.new
  end

  def create
    if @user = User.find_by(email: user_params[:email])
      if @user.try(:authenticate, user_params[:password])
        session[:user_id] = @user.id
        redirect_to newsfeeds_path, notice: "Logged in!"
      else
        _not_authorized "Email or password does not match"
      end
    else
      _not_authorized "Email or password does not match"
    end
  end

  def facebook
    profile = FbGraph2::User.me(params[:access_token]).fetch
    @user = User.find_by(facebook: profile.id)
    if @user.nil?
      redirect_to sign_in_url, notice: "Can't find an user with this Facebook account :("
    else
      session[:user_id] = @user.id
      redirect_to newsfeeds_path, notice: "Logged in!"
    end
  rescue FbGraph2::Exception  => err
    # _not_authorized err.message
    logger.error err.message
    _not_authorized "Problem connecting to Facebook. Please try again later."
  end

  def destroy
  end

  private

    def user_params
      params.require(:user).permit(:name, :username, :email, :password, :avatar, :website, :location, :bio)
    end

end
