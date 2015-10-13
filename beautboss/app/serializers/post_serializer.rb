class PostSerializer < ActiveModel::Serializer

  attributes :id, :category, :service, :place, :image, :comments, :wows, :created_at

  has_one :user, serializer: UserBasicSerializer
  # has_one :place, serializer: PlaceSerializer

  def place
    object.place unless object.place.nil?
  end

  def comments
    object.comments.size
  end

  def wows
    object.wows.size
  end

end
