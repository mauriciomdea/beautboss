class ActivitySerializer < ActiveModel::Serializer

  attributes :created_at, :subject, :url, :message, :image, :read

  # attributes :created_at, :type, :url, :subject_id, :subject_type, :read

  has_one :actor, serializer: UserBasicSerializer

  # has_one :subject

  def subject

    case object.subject_type
    
    when 'User'     # Somebody started following you
      :follow
    when 'Wow'      # Somebody wowed your register
      :wow
    when 'Comment'  # Somebody said: "Comment"
      :comment
    when 'Message'  # Somebody sent a message to you
      :message
    when 'Post'
      :post
    else
      :unknow
    end

  end

  def message 
    if object.subject_type == 'Comment'
      Comment.find(object.subject_id).comment
    elsif object.subject_type == 'Message'
      Message.find(object.subject_id).message
    else
      nil
    end
  end

  def image 

    case object.subject_type
    
    when 'User'
      object.subject.avatar
    when 'Wow'
      object.subject.post.image
    when 'Comment'
      object.subject.post.image
    when 'Post'
      object.subject.image
    when 'Message'
      object.subject.sender.image
    else
      nil
    end

  end

end

