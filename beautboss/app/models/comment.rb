class Comment < ActiveRecord::Base

  belongs_to :post
  belongs_to :user

  validates_presence_of :post, :user, :comment

  validates :comment, length: { maximum: 767 }

end
