class PostSerializer < ActiveModel::Serializer
  attributes :id, :caption, :image, :category, :service, :created_at
  has_one :user, serializer: UserSerializer
  has_one :place, serializer: PlaceSerializer
end
