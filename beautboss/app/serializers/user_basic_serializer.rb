class UserBasicSerializer < ActiveModel::Serializer
  attributes :id, :name, :username, :avatar, :location
end
