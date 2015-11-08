class WowSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :created_at
  has_one :user, serializer: UserBasicSerializer
  # has_one :post, serializer: PostBasicSerializer
end
