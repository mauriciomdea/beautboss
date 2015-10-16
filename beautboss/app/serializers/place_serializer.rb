class PlaceSerializer < ActiveModel::Serializer
  attributes :foursquare_id, :name, :latitude, :longitude, :address, :contact, :website, :created_at
end
