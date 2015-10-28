class RegisterSerializer < ActiveModel::Serializer

  attributes :id, :category, :latitude, :longitude, :service, :image, :user, :place, :comments, :wows, :wowed, :created_at

  has_one :user, serializer: UserBasicSerializer
  # has_one :place, serializer: PlaceSerializer

  def place
    PlaceSerializer.new(object.place).as_json(root: false) unless object.place.nil?
  end

end
