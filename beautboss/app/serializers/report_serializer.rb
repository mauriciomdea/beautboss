class ReportSerializer < ActiveModel::Serializer

  attributes :id, :flag, :explanation, :created_at

  has_one :user, serializer: UserBasicSerializer
  has_one :post, serializer: PostBasicSerializer

  def flag
    object.flag.humanize
  end

end
