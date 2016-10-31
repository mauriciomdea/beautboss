class MessageSerializer < ActiveModel::Serializer
  attributes :id, :message, :created_at
  has_one :user, serializer: UserBasicSerializer
  has_one :sender, serializer: UserBasicSerializer
end