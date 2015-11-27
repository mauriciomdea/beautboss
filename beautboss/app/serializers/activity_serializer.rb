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
    when 'Post'
      :post
    else
      :unknow
    end

  end

  def message 
    if object.subject_type == 'Comment'
      Comment.find(object.subject_id).comment
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
    else
      nil
    end

  end

end

