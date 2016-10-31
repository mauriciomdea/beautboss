class Message < ActiveRecord::Base

  belongs_to :user
  belongs_to :sender, class_name: "User"

  validates :user_id, presence: true
  validates :sender_id, presence: true
  validates :message, presence: true, length: { maximum: 767 }

end
