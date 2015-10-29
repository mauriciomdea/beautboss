class FriendSerializer < ActiveModel::Serializer
  
  attributes :id, :name, :username, :email, :avatar, :location, :is_following

end
