class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :website, :location, :bio
end
