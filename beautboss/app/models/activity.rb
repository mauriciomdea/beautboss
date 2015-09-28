class Activity < ActiveRecord::Base

  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_one :actor, class_name: 'User', foreign_key: :actor_id
  belongs_to :subject, polymorphic: true

  def self.render(activity)

    case activity.trackable_type
    when 'User' # Somebody started following you
      {
        action: activity.key,
        message: I18n.translate('notifications.follow', name: User.find(activity.trackable_id).name),
        url: "/api/v1/users/#{activity.trackable_id}",
        datetime: activity.created_at
       }.to_json
    when 'Wow' # Somebody wowed your register
      {
        action: activity.key,
        message: I18n.translate('notifications.wow', name: User.find(activity.owner_id).name),
        url: "/api/v1/posts/#{activity.trackable_id}",
        datetime: activity.created_at
       }.to_json
    when 'Comment' # Somebody said: "Comment"
      {
        action: activity.key,
        message: I18n.translate('notifications.comment', name: User.find(activity.owner_id).name, comment: Comment.find(activity.trackable_id).comment[0..140]),
        url: "/api/v1/posts/#{activity.trackable_id}",
        datetime: activity.created_at
       }.to_json
    # when 'Post'
    else
      "Unknow activity."
    end

  end

end
