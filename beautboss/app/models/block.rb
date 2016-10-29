class Block < ActiveRecord::Base

  belongs_to :user
  belongs_to :troll, class_name: "User"

  validates :user_id, presence: true
  validates :troll_id, presence: true

end
