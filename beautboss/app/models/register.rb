class Register
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :id, :category, :latitude, :longitude, :service, :place, :image, :comments, :wows, :wowed, :created_at, :post, :observer

  validates_presence_of :post, :observer

  def id
    post.id
  end

  def category
    post.category
  end

  def service 
    post.service
  end

  def image 
    post.image
  end

  def latitude 
    post.latitude
  end

  def longitude 
    post.longitude
  end

  def user 
    post.user
  end

  def place 
    post.place
  end

  def comments 
    post.comments.count
  end

  def wows 
    post.wows_count
  end

  def created_at 
    post.created_at
  end

  def wowed
    post.wowed?(observer)
  end

end
