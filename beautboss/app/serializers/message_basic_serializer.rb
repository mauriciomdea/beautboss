class MessageBasicSerializer < ActiveModel::Serializer
  attributes :id, :message, :read, :created_at
end