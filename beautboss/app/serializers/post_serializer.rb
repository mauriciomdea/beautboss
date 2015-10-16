class PostSerializer < ActiveModel::Serializer

  attributes :id, :category, :latitude, :longitude, :service, :place, :image, :comments, :wows, :created_at

  has_one :user, serializer: UserBasicSerializer
  # has_one :place, serializer: PlaceSerializer

  def place
    PlaceSerializer.new(object.place).as_json(root: false) unless object.place.nil?
  end

  def comments
    object.comments.size
  end

  def wows
    object.wows.size
  end

end
