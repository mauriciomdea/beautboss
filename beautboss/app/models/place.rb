class Place < ActiveRecord::Base
  geocoded_by :address
  # after_validation :geocode

	has_many :posts

  validates_presence_of :foursquare_id
  validates_uniqueness_of :foursquare_id

  def self.search(latitude, longitude, query)

    response = self.foursquare_client.search_venues(:ll => "#{latitude},#{longitude}", :query => query)
    results = []
    response.venues.each { |venue| results << from_foursquare(venue) }
    results

  end

  def self.from_foursquare(attributes)
      place = Place.where(foursquare_id: attributes.id).first_or_initialize do |p|
        p.foursquare_id = attributes.id
        p.name = attributes.name.encode("UTF-8")
        p.latitude = attributes.location.lat
        p.longitude = attributes.location.lng
        p.address = attributes.location.formattedAddress
        p.contact = attributes.contact.phone
        p.website = attributes.url
      end
    end

  private

    def self.foursquare_client
      client = Foursquare2::Client.new(
        :client_id => ENV['FOURSQUARE_ID'], 
        :client_secret => ENV['FOURSQUARE_SECRET'], 
        :api_version => '20150915')
    end
	
end
