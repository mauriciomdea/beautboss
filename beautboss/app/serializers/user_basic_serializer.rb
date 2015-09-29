class UserBasicSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar
end
