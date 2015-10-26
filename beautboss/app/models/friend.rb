class Friend
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :id, :name, :email, :avatar, :location, :following, :user, :other_user

  validates_presence_of :user, :other_user

  def id
    user.id
  end

  def name 
    user.name
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

  def following
    user.following?(other_user)
  end

end
