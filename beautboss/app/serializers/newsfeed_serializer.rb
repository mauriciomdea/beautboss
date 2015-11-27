class NewsfeedSerializer < ActiveModel::Serializer

  attributes :created_at, :subject, :user, :post

  def user
    UserBasicSerializer.new(object.actor).as_json(root: false)
  end

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

  def post

    case object.subject_type
    
    when 'User'
      nil
    when 'Wow'
      PostBasicSerializer.new(object.subject.post).as_json(root: false)
    when 'Comment'
      PostBasicSerializer.new(object.subject.post).as_json(root: false)
    when 'Post'
      PostBasicSerializer.new(object.subject).as_json(root: false)
    else
      nil
    end

  end

end

