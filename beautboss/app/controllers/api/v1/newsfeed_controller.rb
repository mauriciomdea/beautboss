class Api::V1::NewsfeedController < Api::V1::ApiController
  before_action :authenticate_user

  def all

    newsfeed = Activity.where("actor_id IN (?)", @current_user.following.pluck(:id)).limit(params[:limit] || 20).offset(params[:offset] || 0).order(created_at: :desc)
    count = Activity.where("actor_id IN (?)", @current_user.following.pluck(:id)).count
    serialized_newsfeed = newsfeed.map { |activity| NewsfeedSerializer.new(activity).as_json(root: false) unless activity.subject_type == "User" }
    render json: {count: count, news: serialized_newsfeed.compact },
      location: "/api/v1/newsfeed/all",
      status: :ok

  end

  def registers

    newsfeed = Post.where("user_id IN (?)", @current_user.following.pluck(:id)).limit(params[:limit] || 20).offset(params[:offset] || 0).order(created_at: :desc)
    count = Post.where("user_id IN (?)", @current_user.following.pluck(:id)).count
    serialized_newsfeed = newsfeed.map { |post| RegisterSerializer.new(Register.new(post: post, observer: @current_user)).as_json(root:false) }
    render json: {count: count, posts: serialized_newsfeed.compact },
      location: "/api/v1/newsfeed/registers",
      status: :ok

  end

end
