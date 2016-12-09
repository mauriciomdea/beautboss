class Message < ActiveRecord::Base
  before_save :check_for_blocked_user

  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  has_many :activities, as: :subject, dependent: :delete_all

  validates :user_id, presence: true
  validates :sender_id, presence: true
  validates :message, presence: true, length: { maximum: 767 }

  private

    def check_for_blocked_user
      if Block.find_by(user_id: self.user.id, troll_id: self.sender.id)
        self.blocked = true
        raise ActiveRecord::RecordNotFound
      end
    end

end
