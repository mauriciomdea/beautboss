class Post < ActiveRecord::Base
  acts_as_mappable default_units: :kms,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

	belongs_to :user
	belongs_to :place

  has_many :wows, dependent: :delete_all
  has_many :comments, dependent: :delete_all
  has_many :reports, dependent: :delete_all

  enum category: [:haircut, :hairstyle, :colouring, :highlights, :nails, :makeup]

	validates_presence_of :user, :category, :service, :image

end
