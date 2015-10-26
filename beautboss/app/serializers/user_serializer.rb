class UserSerializer < ActiveModel::Serializer

  attributes :id, :name, :username, :email, :facebook, :avatar, :website, :location, :bio, :created_at

end
