class PlaceSerializer < ActiveModel::Serializer
  attributes :id, :foursquare_id, :name, :lat, :lon, :address, :contact, :website
end
