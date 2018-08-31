require_relative "../config/environment.rb"

def run_interface
  mode = :search
  sort_type = "rating"
  while mode
    keyword = ask_for_keyword(mode)
    mode = nil if keyword == "quit"

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

  table_header = ["Distance", "Rating", "Name", "Address"]
  table_rows = []
  places.each do |place|
    table_rows << ["#{place.distance} miles", "#{place.rating} / 5", place.name, place.address]
  end
  table = TTY::Table.new(table_header, table_rows)
  pastel = Pastel.new
  rendered_table = table.render(:ascii) do |renderer|
    # renderer.alignment = [:center]
    renderer.border.style = :green
    renderer.padding = [0,1,0,1]
    renderer.filter = proc do |val, row_index, col_index|
      bolded_column = sort_by == "distance" ? 0 : 1 # this code is terrible.
      col_index == bolded_column && row_index == 0 ? pastel.bold(val) : val
    end
  end
  puts rendered_table
end

def sort_places(places, sort_by)
  case sort_by
  when "rating"
    places = (places.sort_by {|place| place.rating}).reverse
  when "distance"
    places.sort_by! {|place| place.distance}
  end
  places
end

def ask_for_keyword(mode)
  case mode
  when :search
    puts "Enter restaurant type to search for, or quit to exit"
  when :sort_type
    puts "Enter 'rating' or 'distance' to re-sort, 'new' to start a new search, or 'quit' to exit"
  end
  gets.chomp!
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
