class Wow < ActiveRecord::Base

  belongs_to :post, counter_cache: true
  belongs_to :user
  has_many :activities, as: :subject, dependent: :delete_all

  validates_presence_of :post, :user

end
