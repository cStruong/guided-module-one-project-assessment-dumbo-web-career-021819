require 'pry'
require_relative '../config/environment.rb'

=begin
To Do list:
-delete avg rating column, add as a method + display when showing driver info
- create error prompts for wrong input
- format display nicer
-for reads, use iterator to iterate and display all info
=end


class CommandLineInterface

  def invalid_command
    puts "That is not a valid command."
    puts "Please try again."
  end

  # def menu_list
  #   menu = {
  #     "Find a Driver" => -> do puts "Method for finding driver" end,
  #     "Find a Passenger" => -> do puts "method for finding a passenger" end,
  #     "Create a trip" => -> do puts "method for creating a trip" end,
  #     "Delete a trip" => -> do puts "method to delete a trip" end,
  #     "Give/Change a rating for a trip" => -> do puts "method for updating a rating" end
  #   }
  #   menu
  # end

  def command_list
    puts "Here is a list of commands: \n
    [1] Find a Driver\n
    [2] Find a Passenger\n
    [3] Give or Change a trip rating out of 5\n
    [4] Create a trip\n
    [5] Delete a trip\n
    [6] View my trips\n
    [7] Exit"
    command_selection = gets.chomp
    if command_selection == "1"
      search_drivers
    elsif command_selection == "2"
      search_passengers
    elsif command_selection == "3"
      update_rating
    elsif command_selection == "4"
      create_trip
    elsif command_selection == "5"
      delete_trip
    elsif command_selection == "6"
      view_trip
    elsif command_selection == "7"
      puts "Good bye!"
    else
      invalid_command
      command_list
    end
  end

  ########## SEARCH DRIVERS [1] ############

  def search_drivers
    puts "Search by: \n
    [1] Name\n
    [2] License Plate\n
    [3] View All Drivers in Database\n
    [4] View All My Drivers\n
    [5] Cancel"
    search_selection = gets.chomp

    if search_selection == "1"
      puts "Input Driver name: (case sensitive)"
      search_name_input = gets.chomp
      puts "-----------------DRIVER INFO-------------------"
      driver = Driver.find_by(name: search_name_input)
        if driver == nil
          puts "Driver not in database. Please try again."
          search_drivers
        else
          puts "\n
          DRIVER ID : #{driver.id}\n
          NAME : #{driver.name}\n
          PLATES : #{driver.plates}\n
          AVERAGE RATING : #{average_rating(driver.id)}"
          puts "-----------------------------------------------"
          command_list
        end
    elsif search_selection == "2"
      puts "Input License Plate: "
      search_license_plate = gets.chomp
      puts "------------------DRIVER INFO-------------------"
      driver = Driver.find_by(plates: search_license_plate)
        if driver == nil
          puts "Invalid License Plate. Not in database. Please try again."
          search_drivers
        else
          puts "\n
          DRIVER ID : #{driver.id}\n
          NAME : #{driver.name}\n
          PLATES : #{driver.plates}
          AVERAGE RATING : #{average_rating(driver.id)}"
          puts "------------------------------------------------"
          command_list
        end
    elsif search_selection == "3"
      puts "Loading all drivers...."
      all_drivers = Driver.all
      puts "------------------DRIVER INFO-------------------"
      all_drivers.each {|driver|
      puts "\n
      DRIVER ID : #{driver.id}\n
      NAME : #{driver.name}\n
      PLATES : #{driver.plates}\n
      AVERAGE RATING : #{average_rating(driver.id)}\n
      ___________________________"
      }
      puts "------------------------------------------------"
      command_list
    elsif search_selection == "4"
      puts "Loading all your previous drivers..."
      puts "What is your Phone Number? "
      phone_input = gets.chomp
      passenger = Passenger.find_by(phone: phone_input)
        if passenger == nil
          puts "Invalid Phone Number. Not in database. Please try again."
          search_drivers
        else
          passengers_drivers = passenger.drivers
          puts "Here are all your previous drivers : "
          puts "------------------DRIVER INFO-------------------"
          passengers_drivers.each {|driver|
            puts "\n
            DRIVER ID : #{driver.id}\n
            NAME : #{driver.name}\n
            PLATES : #{driver.plates}\n
            AVERAGE RATING : #{average_rating(driver.id)}\n
            ___________________________"
          }
          command_list
        end
    elsif search_selection == "5"
      command_list
    else
      invalid_command
      search_drivers
    end
  end

  ############ SEARCH PASSENGER [2] #############

  def search_passengers
    puts "Search by: \n
    [1] Name \n
    [2] Phone Number \n
    [3] View all Passengers in Database\n
    [4] Cancel"

    search_selection = gets.chomp

    if search_selection == "1"
      puts "Input Passenger name: "
      search_name_input = gets.chomp
      puts "-----------------PASSENGER INFO-----------------"
      passenger = Passenger.find_by(name: search_name_input)
        if passenger == nil
          puts "Passenger not in database. Please try again."
          search_passengers
        else
          puts "\n
          PASSENGER ID : #{passenger.id}\n
          NAME : #{passenger.name}\n
          PHONE NUMBER : #{passenger.phone}"
          puts "------------------------------------------------"
          command_list
        end
    elsif search_selection == "2"
      puts "Input Phone Number (do not include dash): "
      search_phone_input = gets.chomp
      puts "-----------------PASSENGER INFO-----------------"
      passenger = Passenger.find_by(phone: search_phone_input)
        if passenger == nil
          puts "Invalid Phone Number. Not in database. Please try again."
          search_passengers
        else
          puts "\n
          PASSENGER ID : #{passenger.id}\n
          NAME : #{passenger.name}\n
          PHONE NUMBER : #{passenger.phone}"
          puts "------------------------------------------------"
          command_list
        end
    elsif search_selection == "3"
      puts "Loading all Passengers...."
      all_passengers = Passenger.all
      all_passengers.each {|passenger|
        puts "\n
        PASSENGER ID : #{passenger.id}\n
        NAME : #{passenger.name}\n
        PHONE NUMBER : #{passenger.phone}\n
        ___________________________"
      }
      command_list
    elsif search_selection == "4"
      command_list
    else
      invalid_command
      search_passengers
    end
  end


################ CREATE A TRIP [4] ##################

  def create_trip
    puts "Creating a new trip..."
    puts "Type exit to return to main menu.
    Please input the License Plate of your driver: "
    license_plate_input = gets.chomp

    if license_plate_input == "exit"
      command_list
    else
      puts "Please input your Phone Number (do not include dash):"
      passenger_phone_input = gets.chomp
      driver = Driver.find_by(plates: license_plate_input)
      passenger = Passenger.find_by(phone: passenger_phone_input.to_i)

      if driver == nil
        puts "Invalid License Plate. Not in database. Please try again."
        create_trip
      elsif passenger == nil
        puts "Invalid Phone Number. Not in database. Please try again."
        create_trip
      else
      Trip.create(driver_id: driver.id, passenger_id: passenger.id)
      puts "Your trip has been created! Have a good day!"
      command_list
      end
    end
  end


  ############### DELETE A TRIP [5] #################

  def delete_trip
    puts "Canceling a trip..."
    puts "Are you a driver or passenger?\n
    [1] Driver\n
    [2] Passenger\n
    [3] Return to Main menu"
    user_self_input = gets.chomp

    if user_self_input == "1"
      puts "Welcome! You are a driver!"
      puts "What is your License Plate?"
      license_plate_input = gets.chomp
      puts "Here are a list of your trips: "
      driver = Driver.find_by(plates: license_plate_input)
      drivers_trips = driver.trips
      drivers_trips.each {|trip|
        passenger = Passenger.find(trip.passenger_id)
        puts "\n
         TRIP ID : #{trip.id}\n
         PASSENGER ID : #{trip.passenger_id}\n
         PASSENGER : #{passenger.name}\n
         DRIVER ID : #{trip.driver_id}\n
         DRIVER : #{driver.name}\n
         TRIP CREATED ON : #{trip.created_at}\n
         ___________________________"
      }
      puts "What is the ID of the trip you want to delete?"
      driver_trip_id = gets.chomp
      driver_trip = Trip.find(driver_trip_id.to_i)
      driver_trip.destroy
      puts "Your trip has been removed!"
      command_list

    elsif user_self_input == "2"
      puts "Welcome! You are a passenger!"
      puts "What is your Phone Number?"
      phone_input = gets.chomp
      puts "Here are a list of your trips: "
      passenger = Passenger.find_by(phone: phone_input)
      passengers_trips = passenger.trips
      passengers_trips.each {|trip|
        driver = Driver.find(trip.driver_id)
        puts "\n
         TRIP ID : #{trip.id}\n
         PASSENGER ID : #{trip.passenger_id}\n
         PASSENGER : #{passenger.name}\n
         DRIVER ID : #{trip.driver_id}\n
         DRIVER : #{driver.name}\n
         TRIP CREATED ON : #{trip.created_at}\n
         ___________________________"
      }
      puts "What is the ID of the trip you want to delete?"
      passenger_trip_id = gets.chomp
      passenger_trip = Trip.find(passenger_trip_id.to_i)
      passenger_trip.destroy
      puts "Your trip has been removed!"
      command_list
    elsif user_self_input == "3"
      command_list
    else
      invalid_command
      delete_trip
    end
  end

################ UPDATE A RATING [3] ##################

  # def rating_getter
  #   puts "What would you like rate your trip out of 5?"
  #   rating = gets.chomp
  #     if rating.to_i.between?(1,5) == false
  #       puts "Please choose a number between 1 and 5"
  #       rating_getter
  #     end
  #   return rating.to_i
  # end

  def rating_getter
    puts "What would you like rate your trip out of 5?"
    rating = gets.chomp

    until rating.to_i.between?(1,5) == true
      puts "Please choose a number between 1 and 5"
      rating = gets.chomp
    end
    rating.to_i
  end

  def update_rating
    puts "Intializing Rating Updater..."
    puts "Type exit to return to main menu.

    What is your Phone Number?"
    phone_input = gets.chomp

    if phone_input == "exit"
      command_list
    else
      passenger = Passenger.find_by(phone: phone_input.to_i)
        if passenger == nil
          puts "Invalid Phone Number. Not in database. Please try again."
          update_rating
        else
          passengers_trips = passenger.trips
          puts "Here are a list of all your trips: "
          passengers_trips.each {|trip|
            driver = Driver.find(trip.driver_id)
            puts "\n
            TRIP ID : #{trip.id}\n
            PASSENGER ID : #{trip.passenger_id}\n
            PASSENGER : #{passenger.name}\n
            DRIVER ID : #{trip.driver_id}\n
            DRIVER : #{driver.name}\n
            TRIP CREATED ON : #{trip.created_at}\n
            RATING : #{trip.trip_rating}
            ___________________________"
          }
          puts "Insert ID of trip to change its rating."
          trip_id = gets.chomp
          trip = Trip.find(trip_id.to_i)
            if trip == nil
              puts "You don't have that trip. Please try again."
              update_rating
            else
              user_rating = rating_getter
              trip.trip_rating = user_rating
              trip.save
              puts "Your rating has been updated!"
              command_list
            end
        end
      end
    end

############# VIEW MY TRIPS [6] ###################

  def view_trip
    puts "Viewing trips...."
    puts "Are you a driver or Passenger?\n
    [1] Driver\n
    [2] Passenger\n
    [3] Return to Main menu"
    user_self_input = gets.chomp

    if user_self_input == "1"
      puts "You are a driver!\n
      What is your License Plate?"
      license_plate_input = gets.chomp
      puts "Here are a list of your trips: "
      driver = Driver.find_by(plates: license_plate_input)
        if driver == nil
          puts "Invalid License plate. Not in database. Please try again."
          view_trip
        else
          drivers_trips = driver.trips
          drivers_trips.each {|trip|
            passenger = Passenger.find(trip.passenger_id)
            puts "\n
             TRIP ID : #{trip.id}\n
             PASSENGER ID : #{trip.passenger_id}\n
             PASSENGER : #{passenger.name}\n
             PASSENGER PHONE : #{passenger.phone}\n
             DRIVER ID : #{trip.driver_id}\n
             DRIVER : #{driver.name}\n
             TRIP CREATED ON : #{trip.created_at}\n
             RATING : #{trip.trip_rating}\n
             ___________________________"
          }
          command_list
        end
    elsif user_self_input == "2"
      puts "Welcome! You are a passenger!"
      puts "What is your Phone Number?"
      phone_input = gets.chomp
      puts "Here are a list of your trips: "
      passenger = Passenger.find_by(phone: phone_input)
        if passenger == nil
          puts "Invalid Phone Number. Not in database. Please try again."
          view_trip
        else
          passengers_trips = passenger.trips
          passengers_trips.each {|trip|
            driver = Driver.find(trip.driver_id)
            puts "\n
             TRIP ID : #{trip.id}\n
             PASSENGER ID : #{trip.passenger_id}\n
             PASSENGER : #{passenger.name}\n
             DRIVER ID : #{trip.driver_id}\n
             DRIVER : #{driver.name}\n
             TRIP CREATED ON : #{trip.created_at}\n
             RATING : #{trip.trip_rating}\n
             ___________________________"
          }
          command_list
        end
    elsif user_self_input == "3"
      command_list
    else
      invalid_command
      view_trip
    end
  end

        ######################## STRETCH GOALS ########################
=begin
-create driver
-create passengers
-average rating for drivers
=end
######### AVERAGE RATING ############

  def average_rating(driver_id)
    arr_all_trips = Trip.all
    arr_driver_trip = arr_all_trips.select {|trip|
      trip.driver_id == driver_id
    }
    arr_of_ratings = arr_driver_trip.map {|drivers_trip|
      drivers_trip.trip_rating
    }

    if arr_of_ratings.length == 0
      return "NO RATINGS"
    else
      sum = arr_of_ratings.compact.sum
      avg = sum.to_f / (arr_of_ratings.compact.length)
      avg.round(1)
    end
  end

end
