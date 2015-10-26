class FriendSerializer < ActiveModel::Serializer
  
  attributes :id, :name, :email, :avatar, :location, :following

end
