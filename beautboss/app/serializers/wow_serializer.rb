class WowSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :user_id, :created_at
end
