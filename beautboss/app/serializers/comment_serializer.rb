class CommentSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :user_id, :comment, :created_at
end
