class Place
  # @@all = []

  attr_accessor :location, :id, :name, :open_now, :rating, :types, :address, :distance, :eta

  def self.parse_api_data(data)
    #build base data
    places = []
    data.each do |result|
      places << self.create(result)
    end

    #add distance data
    distances = Data_Requester.get_distances_to(places)
    places.each_with_index do |place, i|
      place.distance = distances[i]["distance"]["text"].chomp(" km").to_f
    end
    places
  end

  private

  def self.create(info)
    place = self.new
    # desired_data_fields = ["geometry/location","place_id","name"]
    # kinda wanna use .send to let me iterate through these but w/e
    place.location = info["geometry"]["location"]
    place.id = info["place_id"]
    place.name = info["name"]
    place.open_now = info["opening_hours"]
    place.rating = info["rating"]
    place.types = info["types"]
    place.address = info["vicinity"]
    place
  end

  # def self.all_places
  #   @@all
  # end
end
