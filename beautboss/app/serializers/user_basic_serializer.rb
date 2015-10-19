class UserBasicSerializer < ActiveModel::Serializer
  attributes :id, :name, :avatar, :location
end
