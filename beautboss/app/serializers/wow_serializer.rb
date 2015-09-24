class WowSerializer < ActiveModel::Serializer
  attributes :id, :created_at
  has_one :user, serializer: UserSerializer
  has_one :post, serializer: PostSerializer
end
