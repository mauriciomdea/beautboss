class Post < ActiveRecord::Base

	belongs_to :user
	belongs_to :service
	belongs_to :place
	belongs_to :category

  has_many :wows
  has_many :comments

	validates_presence_of :user, :place, :image

end
