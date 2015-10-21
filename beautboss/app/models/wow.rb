class Wow < ActiveRecord::Base

  belongs_to :post, counter_cache: true
  belongs_to :user

  validates_presence_of :post, :user

end
