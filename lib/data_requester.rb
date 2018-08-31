class Data_Requester
  @@api_key = "AIzaSyATBqOgLuF5nHpFnmBTdSBu22SGXin6N7A"
  def self.get_data_for_keyword(keyword)
    data = request_nearby_places_data(keyword)
    JSON.parse(data)
  end

  # def run
  #   data = request_nearby_places_data
  #   json_hash = JSON.parse(data)
  #
  #   json_hash["results"].each do |result|
  #     puts "Added #{Place.create(result).name}"
  #     # detailed_data = request_place_details(result["place_id"])
  #   end
  #
  #   binding.pry
  #   # puts JSON.pretty_generate(json_hash)
  # end

  def self.request_nearby_places_data(keyword)
    coords = {x: "29.7590907", y: "-95.3634632"}
    radius = 500
    request_url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{coords[:x]},#{coords[:y]}&radius=#{radius}&type=restaurant&keyword=#{keyword}&key=#{@@api_key}"
    RestClient.get(request_url)
  end

  def self.get_distance_to(destination)
    flatiron_address = "708+S+Main+St,+Houston,+TX"
    self.get_distance_between(flatiron_address, destination)
  end

  def self.get_distance_between(address1, address2)
    request_url = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=#{address1}&destinations=#{address2}&key=#{@@api_key}"
    encoded_url = URI.encode(request_url) ## prevent weird characters in the address from breaking shit
    distance_matrix_data = JSON.parse(RestClient.get(encoded_url))

    distance = distance_matrix_data["rows"][0]["elements"][0]["distance"]["text"].chomp(" mi").to_f
    eta = distance_matrix_data["rows"][0]["elements"][0]["duration"]["text"]
    {"distance" => distance, "eta" => eta}
  end

  def request_place_details(place_id)
    request_url = "https://maps.googleapis.com/maps/api/place/details/json?key=#{@@api_key}&placeid=#{place_id}&fields=address_component,adr_address,alt_id,formatted_address,geometry,icon,id,name,permanently_closed,place_id,plus_code,scope,type,url,utc_offset,vicinity"
    RestClient.get(request_url)
  end

  def find_single_place()
    coords = {x: "29.7590907", y: "-95.3634632"}
    radius = 2000
    request_url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=restaurant&inputtype=textquery&fields=name,place_id,types,geometry&locationbias=circle:#{radius}@#{coords[:x]},#{coords[:y]}&key=#{@@api_key}"
    RestClient.get(request_url)
  end
end

# https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=YOUR_API_KEY
