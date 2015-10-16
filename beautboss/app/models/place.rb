class Place < ActiveRecord::Base
  acts_as_mappable default_units: :kms,
                   lat_column_name: :latitude,
                   lng_column_name: :longitude

	has_many :posts

  validates_presence_of :foursquare_id
  validates_uniqueness_of :foursquare_id

  def self.search(latitude, longitude, query, limit=20)

    response = self.foursquare_client.search_venues(ll: "#{latitude},#{longitude}", query: query, limit: limit)
    results = []
    response.venues.each { |venue| results << get_from_foursquare(venue) }
    results

  end

  def self.get_from_foursquare(attributes)
    place = Place.where(foursquare_id: attributes.id).first_or_initialize do |p|
      p.foursquare_id = attributes.id
      p.name = attributes.name.encode("UTF-8")
      p.latitude = attributes.location.lat
      p.longitude = attributes.location.lng
      p.address = attributes.location.address
      p.contact = attributes.contact.phone
      p.website = attributes.url
    end
  end

  def self.create_from_foursquare(id)
    venue = self.foursquare_client.venue(id)
    place = Place.where(foursquare_id: id).first_or_create do |p|
      p.foursquare_id = id
      p.name = venue.name.encode("UTF-8")
      p.latitude = venue.location.lat
      p.longitude = venue.location.lng
      p.address = venue.location.address unless venue.location.address.nil?
      p.contact = venue.contact.phone unless venue.contact.phone.nil?
      p.website = venue.url unless venue.url.nil?
    end
    return place
  end

  private

    def self.foursquare_client
      client = Foursquare2::Client.new(
        :client_id => ENV['FOURSQUARE_ID'], 
        :client_secret => ENV['FOURSQUARE_SECRET'], 
        :api_version => '20150915')
    end
	
end
