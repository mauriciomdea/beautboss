class Post < ActiveRecord::Base

	belongs_to :user
	belongs_to :place

  has_many :wows
  has_many :comments

  enum category: [:haircut, :hairstyle, :colouring, :highlights, :nails, :makeup]

	validates_presence_of :user, :service, :image

end
