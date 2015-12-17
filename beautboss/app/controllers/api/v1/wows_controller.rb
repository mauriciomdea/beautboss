class Api::V1::WowsController < Api::V1::ApiController
  before_action :authenticate_user

  def index
    post = Post.find(params[:id])
    wows = post.wows.limit(params[:limit] || 20).offset(params[:offset] || 0)
    serialized_wows = wows.map { |wow| WowSerializer.new(wow).as_json(root: false) }
    render json: {count: post.wows.size, wows: serialized_wows},
      location: "/api/v1/posts/#{post.id}/wows",
      status: :ok
  rescue ActiveRecord::RecordNotFound
    _not_found
  end

  def create
    user = @current_user
    post = Post.find(params[:id])
    wow = Wow.where(post: post, user: user).first_or_create
    if wow.save
      # saves activity
      activity = Activity.create(owner: post.user, actor: user, subject: wow)
      # sends notifications
      Device.where(user: post.user).each do |device|
        # device.push_notification(I18n.t('notifications.wow', name: @current_user.name))
        device.push_notification(ActivitySerializer.new(activity).as_json(root: false))
      end
      render json: WowSerializer.new(wow).as_json(root: false),
        location: "/api/v1/posts/#{post.id}/wows",
        status: :created
    else
      render json: { errors: wow.errors.full_messages }, status: 422
    end
  end

  def destroy
    wow = Wow.find_by(post_id: params[:id], user_id: @current_user.id)
    if wow.nil?
      _not_found
    else
      wow.destroy
      head :no_content
    end
  end

end
