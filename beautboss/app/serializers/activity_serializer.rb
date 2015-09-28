class ActivitySerializer < ActiveModel::Serializer

  attributes :created_at, :subject, :url, :read

  # attributes :created_at, :type, :url, :subject_id, :subject_type, :read

  # has_one :owner, serializer: UserSerializer

  # has_one :subject

  def subject

    case object.subject_type
    
    when 'User'     # Somebody started following you
      object.subject
    when 'Wow'      # Somebody wowed your register
      :wow
    when 'Comment'  # Somebody said: "Comment"
      :comment
    else
      :unknow
    end

  end

  def url

    case object.subject_type
    
    when 'User'
      "/api/v1/users/#{object.subject_id}"
    when ['Wow', 'Comment']
      "/api/v1/posts/#{object.subject_id.post_id}"
    else
      nil
    end

  end

end

