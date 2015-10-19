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

# {
#     "id": 1,
#     "category": "haircut",
#     "lat": -23.1234,
#     "lon": -46.1234,
#     "service": "Female Haircut",
#     "user": {
#         "id": 2
#         "name": "Jane Smith"
#         "avatar": "https://scontent.xx.fbcdn.net/hprofile-xtp1/v/t1.0-1/p50x50/12038035_10153568053793444_3955325592428203406_n.jpg"
#     },
#     "place": {
#         "id": 123,
#         "name": "Beau London",
#         "lat": -23.1234,
#         "lon": -46.1234
#     },
#     "wow": 26,
#     "wow_friends": 6,
#     "my_wow": false,
#     "url": "http://symphony.clinic/wp-content/uploads/2015/05/haircut.jpg",
#     "created_at": "2015-10-10T16:43:10.000Z"
# }
    