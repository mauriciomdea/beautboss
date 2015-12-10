class NewsfeedSerializer < ActiveModel::Serializer

  attributes :created_at, :subject, :user, :post

  def subject

    case object.subject_type
    when 'User'     # Somebody started following you
      :follow
    when 'Wow'      # Somebody wowed your register
      :wow
    when 'Comment'  # Somebody said: "Comment"
      :comment
    when 'Post'  # Somebody registered
      :post
    else
      :unknow
    end

  end

  def user
    UserBasicSerializer.new(object.actor).as_json(root: false) unless object.actor.nil?
  end

  def post

    case object.subject_type
    when 'User'
      nil
    when 'Wow'
      PostSerializer.new(object.subject.post).as_json(root: false) unless (object.subject.nil? || object.subject.post.nil?)
    when 'Comment'
      PostSerializer.new(object.subject.post).as_json(root: false) unless (object.subject.nil? || object.subject.post.nil?)
    when 'Post'
      PostSerializer.new(object.subject).as_json(root: false) unless object.subject.nil?
    else
      nil
    end

  end

end

