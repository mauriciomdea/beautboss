class NewUserSerializer < ActiveModel::Serializer
  
  attributes :id, :name, :email, :facebook, :avatar, :website, :location, :bio, :created_at

end
