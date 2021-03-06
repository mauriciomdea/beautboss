class Activity < ActiveRecord::Base

  belongs_to :owner, class_name: 'User', foreign_key: :user_id  # the user whose activity will be notified to
  belongs_to :actor, class_name: 'User', foreign_key: :actor_id  # the user who generated the notification
  belongs_to :subject, polymorphic: true  # can be an User, Wow, Comment or Message

  validates :owner, :actor, presence: true

  scope :unread, -> { where(read: false) }

  def url

    case subject_type

    when 'User' # Somebody started following you
      "/api/v1/users/#{actor_id}"
    when 'Wow' # Somebody wowed your register
      "/api/v1/posts/#{Wow.find(subject_id).post.id}/wows"
    when 'Comment' # Somebody said: "Comment"
      "/api/v1/posts/#{Comment.find(subject_id).post.id}/comments"
    when 'Message' # Somebody sent you a message
      "/api/v1/users/#{Message.find(subject_id).user.id}/messages"
    # when 'Post'
    else
      nil
    end

  end

end
