class NewsfeedController < ApplicationController
  before_action :authenticate_user

  def index 
    @newsfeed = Post.where("user_id IN (?)", @current_user.following.pluck(:id)).limit(params[:limit] || 20).order(created_at: :desc)
  end

  def show 
  end

end
