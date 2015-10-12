class PostSerializer < ActiveModel::Serializer

  attributes :id, :caption, :image, :category, :service, :comments, :wows, :created_at

  has_one :user, serializer: UserBasicSerializer
  has_one :place, serializer: PlaceSerializer

  def comments
    object.comments.size
  end

  def wows
    object.wows.size
  end

end
