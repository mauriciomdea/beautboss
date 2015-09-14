class Post < ActiveRecord::Base

	belongs_to :user
	belongs_to :service
	belongs_to :place
	belongs_to :category


end
