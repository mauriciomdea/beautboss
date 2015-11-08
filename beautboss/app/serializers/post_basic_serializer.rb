class PostBasicSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :place_id, :category, :service, :image
end
