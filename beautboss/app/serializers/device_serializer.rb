class DeviceSerializer < ActiveModel::Serializer

  attributes :id, :type, :endpoint

  has_one :user, serializer: UserBasicSerializer

  def type
    object.platform
  end

end
