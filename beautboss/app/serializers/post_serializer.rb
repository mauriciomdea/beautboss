class PostSerializer < ActiveModel::Serializer
  attributes :id, :caption, :image, :user, :place, :category, :service
end
