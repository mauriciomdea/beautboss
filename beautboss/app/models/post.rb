class Post < ActiveRecord::Base
  # reverse_geocoded_by :latitude, :longitude
  acts_as_mappable default_units: :kms,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

	belongs_to :user
	belongs_to :place

  has_many :wows
  has_many :comments

  enum category: [:haircut, :hairstyle, :colouring, :highlights, :nails, :makeup]

	validates_presence_of :user, :service, :image

end
