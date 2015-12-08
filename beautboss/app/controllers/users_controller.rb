class UsersController < ApplicationController
  before_action :authenticate_user

  def show 
    @user = User.find_by!(username: params[:username])
  end

  def edit
  end

  def update

    if @current_user.update(user_params)
      redirect_to edit_user_path(@current_user)
    else
      render :edit
    end

  end

  def destroy

    if @current_user.try(:authenticate, user_params[:password])
      @current_user.destroy
      redirect_to sign_in_path, notice: "Account successfully deleted :("
    else
      @current_user.errors.add(:password, 'is invalid')
      render :edit
    end

  end

  private 

    def user_params
      params.require(:user).permit(:name, :username, :email, :password, :password_confirmation, :avatar, :website, :location, :bio)
    end

end
