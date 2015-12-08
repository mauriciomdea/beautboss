class UsersController < ApplicationController
  before_action :authenticate_user

  def show 
    @user = User.find_by!(username: params[:id])
  end

  def edit
  end

  def update
    if @current_user.update(user_params)
      # render :edit
      redirect_to edit_user_path(@current_user)
    else
      render :edit
    end
  end

  private 

    def user_params
      params.require(:user).permit(:name, :username, :email, :password, :password_confirmation, :avatar, :website, :location, :bio)
    end

end
