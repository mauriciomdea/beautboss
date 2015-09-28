class ActivitySerializer < ActiveModel::Serializer

  attributes :created_at, :subject, :url, :message, :read

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

end

