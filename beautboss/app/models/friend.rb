class Friend
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :id, :name, :username, :email, :avatar, :location, :is_following, :user, :other_user

  validates_presence_of :user, :other_user

  def id
    user.id
  end

  def name 
    user.name
  end

  def username 
    user.username
  end

  def email
    user.email
  end

  def avatar 
    user.avatar
  end

  def location 
    user.location
  end

  def is_following
    other_user.following?(user)
  end

end
