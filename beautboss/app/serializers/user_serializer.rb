class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar, :website, :location, :bio, :created_at
end
