require_relative "./data_requester.rb"
require_relative "./place.rb"

def run_interface
  while true
    keyword = ask_for_keyword
    if keyword
      if keyword != "quit"
        api_data = Data_Requester.get_data_for_keyword(keyword)
        places = Place.parse_api_data(api_data["results"])
        top_places = calculate_top_places(places)
        print_top_places(top_places)
      else
        return
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

def calculate_top_places(places)
  closest_places = places.sort_by {|place| place.distance}
  best_places = (places.sort_by {|place| place.rating}).reverse

  top_places = closest_places[0..2] # should prob not hardcode this
  top_places.concat(best_places[0..2]).uniq
end

def print_top_places(places)
  places.each do |place|
    puts "#{place.name}: distance #{place.distance} miles, rating #{place.rating}/5 (#{place.address})"
  end
end

def ask_for_keyword
  puts "Enter restaurant type to search for, or quit to exit"
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
