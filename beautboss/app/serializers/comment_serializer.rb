class CommentSerializer < ActiveModel::Serializer
  attributes :id, :comment, :created_at
  has_one :user, serializer: UserBasicSerializer
  # has_one :post, serializer: PostSerializer
end
