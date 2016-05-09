class UserSerializer < ActiveModel::Serializer

  attributes :id, :name, :username, :email, :facebook, :avatar, :website, :location, :language, :bio, :created_at

end
