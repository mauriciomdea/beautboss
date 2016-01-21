class Report < ActiveRecord::Base

  belongs_to :post
  belongs_to :user

  enum flag: [:innapropriate, :wrong_location, :closed_or_private, :copyright_infringement, :other]

  validates_presence_of :post, :user, :flag

end
