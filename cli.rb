require_relative "./data_requester.rb"
require_relative "./place.rb"

def run_interface
  mode = :search
  sort_type = "rating"
  while true
    keyword = ask_for_keyword(mode, sort_type)
    if keyword == "quit"
      return
    end

    case mode
    when :search
      if keyword
        places = new_search(keyword)
        print_places(places, sort_type)
        mode = :sort_type
      end
    when :sort_type
      if keyword == "distance" || keyword == "rating"
        sort_type = keyword
        print_places(places, sort_type)
      elsif keyword == "new"
        mode = :search
      end
    end
    # input = ask_for_input
    # command = get_command(input)
    # if command
    #   execute_command(command)
    # else
    #   ask_for_input(true)
    # end
  end
end

def new_search(keyword)
  api_data = Data_Requester.get_data_for_keyword(keyword)
  Place.parse_api_data(api_data["results"])
end

def print_places(places, sort_by)
  places = sort_places(places, sort_by)
  places.each do |place|
    puts "#{place.name}: distance #{place.distance} miles, rating #{place.rating} / 5 (#{place.address})"
  end
end

def sort_places(places, sort_by)
  case sort_by
  when "rating"
    puts "Displaying sorted by rating:"
    places = (places.sort_by {|place| place.rating}).reverse
  when "distance"
    puts "Displaying sorted by distance:"
    places.sort_by! {|place| place.distance}
  end
  places
end

def ask_for_keyword(mode, sort_type)
  case mode
  when :search
    puts "Enter restaurant type to search for, or quit to exit"
  when :sort_type
    puts "Enter 'rating' or 'distance' to re-sort, 'new' to start a new search, or 'quit' to exit"
  end
  gets.chomp
end

run_interface

# def get_command(input_string)
# end
#
# def execute_command(command)
# end
#
# def ask_for_input(failed_command = false)
#   if failed_command
#     puts "Command not recognized."
#   end
#   puts "Enter command"
#   display_commands
#   gets.chomp
# end
#
# def display_commands
#
# end

# Data_Requester.new.run
