class UserFullSerializer < ActiveModel::Serializer
  
  attributes :id, :name, :username, :email, :facebook, :avatar, :website, :location, :bio, :followers, :following, :posts, :is_following, :created_at

  def followers
    object.followers.size
  end

  def following
    object.following.size
  end

  def posts
    object.posts.size
  end

  def is_following
    serialization_options[:current_user].following?(object)
  end

end
