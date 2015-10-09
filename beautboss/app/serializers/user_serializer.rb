class UserSerializer < ActiveModel::Serializer
  
  attributes :id, :name, :email, :facebook, :avatar, :website, :location, :bio, :followers, :following, :created_at

  def followers
    object.followers.size
  end

  def following
    object.following.size
  end

end
