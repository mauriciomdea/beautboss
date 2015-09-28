class ActivitySerializer < ActiveModel::Serializer

  attributes :created_at, :subject, :url, :read

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

end

