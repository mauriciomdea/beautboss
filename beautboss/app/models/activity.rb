class Activity < ActiveRecord::Base

  belongs_to :owner, class_name: 'User', foreign_key: :user_id  # the user whose activity will be notified to
  belongs_to :actor, class_name: 'User', foreign_key: :actor_id  # the user who generated the notification
  belongs_to :subject, polymorphic: true  # can be an User, Wow or Comment

  validates :owner, :actor, presence: true

  def url

    case subject_type

    when 'User' # Somebody started following you
      "/api/v1/users/#{actor_id}"
    when 'Wow' # Somebody wowed your register
      "/api/v1/posts/#{Wow.find(subject_id).post.id}/wows"
    when 'Comment' # Somebody said: "Comment"
      "/api/v1/posts/#{Comment.find(subject_id).post.id}/comments"
    # when 'Post'
    else
      nil
    end

  end

end
