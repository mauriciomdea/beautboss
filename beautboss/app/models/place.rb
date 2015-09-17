class Place < ActiveRecord::Base
  # self.primary_key = :foursquare_id

	has_many :posts

  validates_presence_of :foursquare_id
  validates_uniqueness_of :foursquare_id

  def self.search(lat, lon, query)

    response = self.foursquare_client.search_venues(:ll => "#{lat},#{lon}", :query => query)
    results = []
    response.venues.each { |venue| results << from_foursquare(venue) }
    results

  end

  def self.from_foursquare(attributes)
      place = Place.where(foursquare_id: attributes.id).first_or_initialize do |p|
        p.foursquare_id = attributes.id
        p.name = attributes.name.encode("UTF-8")
        p.lat = attributes.location.lat
        p.lon = attributes.location.lng
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
