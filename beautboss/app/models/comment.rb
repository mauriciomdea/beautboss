class Comment < ActiveRecord::Base

  belongs_to :post
  belongs_to :user

  validates_presence_of :post, :user

end
class Comment < ActiveRecord::Base

  belongs_to :post
  belongs_to :user

  validates_presence_of :post, :user

end