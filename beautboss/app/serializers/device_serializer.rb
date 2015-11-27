class DeviceSerializer < ActiveModel::Serializer

  attributes :id, :device_type, :device_token

  has_one :user, serializer: UserBasicSerializer

end
