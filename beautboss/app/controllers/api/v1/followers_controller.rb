class Api::V1::FollowersController < ApplicationController
  before_action :authenticate_user

  def create 
    follower = @current_user
    followed = User.find(params[:id])
    if follower.follow(followed)
      render json: UserSerializer.new(follower).as_json(root: false),
        location: "/api/v1/users/#{follower.id}/followers",
        status: :created
    else
      render json: { errors: follower.errors.full_messages }, status: 422
    end
  end

  def destroy
    follower = @current_user
    followed = User.find(params[:id])
    if follower.unfollow(followed)
      # followed.create_activity :destroy, owner: @current_user
      head :no_content
    else
      render json: { errors: follower.errors.full_messages }, status: 422
    end
  end

end
