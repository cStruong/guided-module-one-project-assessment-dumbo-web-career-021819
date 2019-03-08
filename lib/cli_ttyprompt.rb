require 'pry'
require_relative '../config/environment.rb'

class CliTty

  def tty_command_list
    prompt = TTY::Prompt.new

    menu = [
    "Find a Driver or Passenger",
    "View my Trips",
    "Create a Trip",
    "Delete a Trip",
    "Give or change a trip rating out of 5",
    "Update data for an existing Driver or Passenger",
    "Enter a new Driver or Passenger into Data Base",
    "Delete a Driver or Passenger from Data Base",
    "Exit"
    ]

    menu_choice = prompt.select("Here are a list of commands: ", menu)
      case menu_choice
      when "Find a Driver or Passenger"
        choice = driver_or_passenger ##see Methods_1##
        if choice == "Driver"
          search_choices = [
            "Name",
            "License Plate",
            "View all Drivers",
            "View my previous Drivers",
            "Main Menu"
          ]
          search_choice = prompt.select("I want to search by: ", search_choices)
            case search_choice
            when "Name"
              search_drivers_by_name ##see Methods_2##
            when "License Plate"
              search_drivers_by_plate ##see Methods_3##
            when "View all Drivers"
              display_all_drivers ##see Methods_4##
            when "View my previous Drivers"
              view_my_drivers ##see Methods_5##
            when "Main Menu"
              tty_command_list
            end
        elsif choice == "Passenger"
          search_choices = [
            "Name",
            "Phone Number",
            "View my previous Passengers",
            "Main Menu"
          ]
          search_choice = prompt.select("I want to search by: ", search_choices)
            case search_choice
            when "Name"
              search_passengers_by_name ##see Methods_6##
            when "Phone Number"
              search_passengers_by_phone ##see Methods_7##
            when "View my previous Passengers"
              view_my_passengers ##see Methods_8##
            when "Main Menu"
              tty_command_list
            end
        elsif choice == "Back"
          tty_command_list
        else
          puts "If you see this theres a big whoopsie somewhere<search>"
        end
      when "View my Trips"
        choice = driver_or_passenger ##see Method_1##
        if choice == "Driver"
          view_trip_history_driver ##see Methods_9##
          tty_command_list
        elsif choice == "Passenger"
          view_trip_history_passenger ##see Methods_10##
          tty_command_list
        elsif choice == "Back"
          tty_command_list
        else
          puts "If you see this theres a big whoopsie somewhere<viewtrips>"
        end
      when "Create a Trip"
        create_trip ##see Methods_11##
      when "Delete a Trip"
        choice = driver_or_passenger ##see Methods_1##
        if choice == "Driver"
          view_trip_history_driver ##see Methods_9##
          delete_trip ##see Methods_12##
        elsif choice == "Passenger"
          view_trip_history_passenger ##see Methods_10##
          delete_trip ##see Methods_12##
        elsif choice == "Back"
          tty_command_list
        else
          puts "If you see this theres a big whoopsie somewhere<deletetrip>"
        end
      when "Give or change a trip rating out of 5"
        view_trip_history_passenger ##see Methods_10##
        update_rating ##see Methods_13 && 13.5##
      when "Update data for an existing Driver or Passenger"
        choice = driver_or_passenger
        if choice == "Driver"
          update_driver_info ##see Methods_14##
        elsif choice == "Passenger"
          update_passenger_info ##see Methods_15##
        elsif choice == "Back"
          tty_command_list
        else
          puts "If you see this theres a big whoopsie somewhere<update info>"
        end
      when "Enter a new Driver or Passenger into Data Base"
        choice = driver_or_passenger
        if choice == "Driver"
          driver_create ##see Methods_16##
        elsif choice == "Passenger"
          passenger_create ##see Methods_17##
        elsif choice == "Back"
          tty_command_list
        else
          puts "If you see this theres a big whoopsie somewhere<enter new>"
        end
      when "Delete a Driver or Passenger from Data Base"
        choice = driver_or_passenger
        if choice == "Driver"
          delete_driver ##see Method_18##
        elsif choice == "Passenger"
          delete_passenger ##see Mehthod_19##
        elsif choice == "Back"
          tty_command_list
        else
          puts "If you see this theres a big whoopsie somewhere<delete>"
        end
      when "Exit"
        puts "Goodbye!"
      end
  end

############################ MY METHODS ############################
  # 1
  # -lets user select if they are driver or passenger.
  def driver_or_passenger
    prompt = TTY::Prompt.new
    prompt.select("Passenger or Driver?", %w(Driver Passenger Back))
  end

  #2
  # - searches and prints driver info from a name input
  def search_drivers_by_name
    puts "
    Input Driver name (case sensitive):
    Type 'exit' to return to main menu"
    search_name_input = gets.chomp
    if search_name_input == "exit"
      tty_command_list
    else
      puts "-----------------DRIVER INFO-------------------"
      driver = Driver.find_by(name: search_name_input)
        if driver == nil
          puts "Driver not in database. Please try again."
          search_drivers_by_name
        else
          puts "\n
          DRIVER ID : #{driver.id}\n
          NAME : #{driver.name}\n
          PLATES : #{driver.plates}\n
          AVERAGE RATING : #{average_rating(driver.id)}"
          puts "-----------------------------------------------"
          tty_command_list
        end
    end
  end

  #3
  # searches and prints driver info from a license plate input
  def search_drivers_by_plate
    puts "
    Input License Plate:
    Type 'exit' to return to main menu"
    search_license_plate = gets.chomp
    if search_license_plate == "exit"
      tty_command_list
    else
      puts "------------------DRIVER INFO-------------------"
      driver = Driver.find_by(plates: search_license_plate)
        if driver == nil
          puts "Invalid License Plate. Not in database. Please try again."
          search_drivers_by_plate
        else
          puts "\n
          DRIVER ID : #{driver.id}\n
          NAME : #{driver.name}\n
          PLATES : #{driver.plates}\n
          AVERAGE RATING : #{average_rating(driver.id)}"
          puts "------------------------------------------------"
          tty_command_list
        end
    end
  end

  #4
  #- displays all drivers in database
  def display_all_drivers
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
    tty_command_list
  end

  #5
  #- displays all drivers that belong to passenger given passenger phone input
  def view_my_drivers
    puts "Loading all your previous drivers..."
    puts "
    What is your Phone Number?
    Type 'exit' to return to main menu"
    phone_input = gets.chomp
      if phone_input == "exit"
        tty_command_list
      else
        passenger = Passenger.find_by(phone: phone_input)
        if passenger == nil
          puts "Invalid Phone Number. Not in database. Please try again."
          view_my_drivers
        else
          passengers_drivers = passenger.drivers
          puts "
          HELLO #{passenger.name}!
          Here are all your previous drivers : "
          puts "------------------DRIVER INFO-------------------"
          passengers_drivers.each {|driver|
            puts "\n
            DRIVER ID : #{driver.id}\n
            NAME : #{driver.name}\n
            PLATES : #{driver.plates}\n
            AVERAGE RATING : #{average_rating(driver.id)}\n
            ___________________________"
          }
          tty_command_list
        end
      end
  end

  #6
  #- search and print passenger info from a name input
  def search_passengers_by_name
    puts "
    Input Passenger name:
    Type 'exit' to return to main menu"
    search_name_input = gets.chomp
    if search_name_input == "exit"
      tty_command_list
    else
      puts "-----------------PASSENGER INFO-----------------"
      passenger = Passenger.find_by(name: search_name_input)
        if passenger == nil
          puts "Passenger not in database. Please try again."
          search_passengers_by_name
        else
          puts "\n
          PASSENGER ID : #{passenger.id}\n
          NAME : #{passenger.name}\n
          PHONE NUMBER : #{passenger.phone}"
          puts "------------------------------------------------"
          tty_command_list
        end
      end
  end

  #7
  #- search and print passenger info from a phone number input
  def search_passengers_by_phone
    puts "
    Input Phone Number (do not include dash):
    Type 'exit' to return to main menu"
    search_phone_input = gets.chomp
    if search_phone_input == "exit"
      tty_command_list
    else
      puts "-----------------PASSENGER INFO-----------------"
      passenger = Passenger.find_by(phone: search_phone_input)
        if passenger == nil
          puts "Invalid Phone Number. Not in database. Please try again."
          search_passengers_by_phone
        else
          puts "\n
          PASSENGER ID : #{passenger.id}\n
          NAME : #{passenger.name}\n
          PHONE NUMBER : #{passenger.phone}"
          puts "------------------------------------------------"
          tty_command_list
        end
      end
  end

  #8
  #- displays all passengers that belong to the driver given driver's plates
  def view_my_passengers
    puts "Loading all your previous passengers..."
    puts "
    What is your License Plate?
    Type 'exit' to return to main menu"
    license_plate_input = gets.chomp
      if license_plate_input == "exit"
        tty_command_list
      else
        driver = Driver.find_by(plates: license_plate_input)
        if driver == nil
          puts "Invalid License Plate. Not in database. Please try again."
          view_my_passengers
        else
          drivers_passengers = driver.passengers
          puts "
          HELLO #{driver.name}!
          Here are all your previous drivers : "
          puts "------------------DRIVER INFO-------------------"
          drivers_passengers.each {|passenger|
            puts "\n
            PASSENGER ID : #{passenger.id}\n
            NAME : #{passenger.name}\n
            PHONE NUMBER : #{passenger.phone}\n
            ___________________________"
          }
          tty_command_list
        end
      end
  end

  #9
  #- view all trip history as a driver
  def view_trip_history_driver
    puts "You are a driver!\n
    What is your License Plate?
    Type 'exit' to return to main menu"
    license_plate_input = gets.chomp
    if license_plate_input == 'exit'
      tty_command_list
    else
      driver = Driver.find_by(plates: license_plate_input)
        if driver == nil
          puts "Invalid License plate. Not in database. Please try again."
          view_trip_history_driver
        else
          puts "Here are a list of your trips: "
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
        end
      end
  end

  #10
  #- view trip history as a passenger
  def view_trip_history_passenger
    puts "Welcome! You are a passenger!"
    puts "
    What is your Phone Number?
    Type 'exit' to return to main menu"
    phone_input = gets.chomp
    if phone_input == 'exit'
      tty_command_list
    else
      puts "Here are a list of your trips: "
      passenger = Passenger.find_by(phone: phone_input)
        if passenger == nil
          puts "Invalid Phone Number. Not in database. Please try again."
          view_trip_history_passenger
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
        end
      end
  end

  #11
  #- creates a trip
  def create_trip
    puts "Creating a new trip..."
    puts "Type 'exit' to return to main menu.
    Please input the License Plate of your driver: "
    license_plate_input = gets.chomp

    if license_plate_input == "exit"
      tty_command_list
    else
      puts "
      Please input your Phone Number (do not include dash):
      Type 'exit' to return to main menu."
      passenger_phone_input = gets.chomp
        if passenger_phone_input == "exit"
          tty_command_list
        else
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
            tty_command_list
          end
        end
    end
  end

  #12
  #- allows driver or passenger to find their trips and delete by trip id
  def delete_trip
    puts "
    What is the ID of the trip you want to delete?
    Type 'exit' to return to main menu."
    trip_id = gets.chomp
      if trip_id == "exit"
        tty_command_list
      else
        trip = Trip.find_by(id: trip_id.to_i)
        if trip == nil
          puts "You do not have a trip with that ID. Please try again."
          delete_trip
        else
          trip.destroy
          puts "Your trip has been removed!"
          tty_command_list
        end
      end
  end

  #13 & 13.5
  #- allows a passenger to rate or update their trip rating
  def rating_getter
    puts "
    What would you like rate your trip out of 5?
    Type 'exit' to return to main menu"
    rating = gets.chomp
    if rating == "exit"
      tty_command_list
    else
      until rating.to_i.between?(1,5) == true
        puts "Please choose a number between 1 and 5"
        rating = gets.chomp
      end
    end
    rating.to_i
  end

  def update_rating
    puts "Intializing Rating Updater..."
    puts "
    Insert ID of trip to change its rating.
    Type 'exit' to return to main menu"
    trip_id = gets.chomp
      if trip_id == "exit"
        tty_command_list
      else
        trip = Trip.find_by(id: trip_id.to_i)
          if trip == nil
          puts "You don't have that trip. Please try again."
          update_rating
          else
          user_rating = rating_getter
          trip.trip_rating = user_rating
          trip.save
          puts "Your rating has been updated!"
          tty_command_list
          end
      end
  end

  #14
  #- lets driver update information
  def update_driver_info
    prompt = TTY::Prompt.new
    puts "
    To update driver information, enter your License Plate:
    Type 'exit' to return to main menu"
    license_plate_input = gets.chomp
    if license_plate_input == "exit"
      tty_command_list
    else
      driver = Driver.find_by(plates: license_plate_input)
      if driver == nil
        puts "Invalid License Plate. Not in database. Please try again."
        update_driver_info
      else
        puts "
        Hello #{driver.name}!"
        update_choices = [
          "Name",
          "License Plate",
          "Company",
          "Back"
        ]
        update_choice = prompt.select("What would you like to change?", update_choices)
        case update_choice
        when "Name"
          puts "
          What is your new Name?
          Type 'exit' to return to main menu"
          user_input = gets.chomp
          if user_input == "exit"
            tty_command_list
          else
            driver.update(name: user_input)
            puts "Update Successful!"
            tty_command_list
          end
        when "License Plate"
          puts "
          What is your new License Plate?
          Type 'exit' to return to main menu"
          user_input = gets.chomp
          if user_input == "exit"
            tty_command_list
          else
            driver.update(plates: user_input)
            puts "Update Successful!"
            tty_command_list
          end
        when "Company"
          puts "
          What is your new Company?
          Type 'exit' to return to main menu"
          user_input = gets.chomp
          if user_input == "exit"
            tty_command_list
          else
            driver.update(company: user_input)
            puts "Update Successful!"
            tty_command_list
          end
        when "Back"
          tty_command_list
        end
      end
    end
  end

  #15
  #-updates passenger info
  def update_passenger_info
    prompt = TTY::Prompt.new
    puts "
    To update passenger information, enter your Phone Number:
    Type 'exit' to return to main menu"
    phone_input = gets.chomp
    if phone_input == "exit"
      tty_command_list
    else
      passenger = Passenger.find_by(phone: phone_input)
      if passenger == nil
        puts "Invalid Phone Number. Not in database. Please try again."
        update_passenger_info
      else
        puts "
        Hello #{passenger.name}!"
        update_choices = [
          "Name",
          "Phone Number",
          "Back"
        ]
        update_choice = prompt.select("What would you like to change?", update_choices)
        case update_choice
        when "Name"
          puts "
          What is your new Name?
          Type 'exit' to return to main menu"
          user_input = gets.chomp
          if user_input == "exit"
            tty_command_list
          else
            passenger.update(name: user_input)
            puts "Update Successful!"
            tty_command_list
          end
        when "Phone Number"
          puts "
          What is your new Phone Number?
          Type 'exit' to return to main menu"
          user_input = gets.chomp
          if user_input == "exit"
            tty_command_list
          else
            passenger.update(phone: user_input)
            puts "Update Successful!"
            tty_command_list
          end
        when "Back"
          tty_command_list
        end
      end
    end
  end

  #16
  #- creates a new driver
    def driver_create
      puts "
      Welcome.
      Creating data for a new DRIVER
      What is your name? (case sensitive):
      Type 'exit' to return to main menu"
      driver_name = gets.chomp
      if driver_name == 'exit'
        tty_command_list
      else
        puts "
        What is your License Plate? (case sensitive):
        Type 'exit' to return to main menu"
        driver_plates = gets.chomp
        if driver_plates == 'exit'
          tty_command_list
        elsif Driver.find_by(plates: driver_plates) != nil
          puts "License Plate already registered."
          tty_command_list
        else
          puts "
          What is your Company? (case sensitive):
          Type 'exit' to return to main menu"
          driver_company = gets.chomp
          if driver_company == 'exit'
            tty_command_list
          else
            Driver.create(name: driver_name, plates: driver_plates, company: driver_company)
            puts "You have been successfully entered into the system!"
            tty_command_list
          end
        end
     end
    end

    #17
    #- creates a new passenger
  def passenger_create
    puts "
    Welcome.\n
    Creating data for a new PASSENGER
    What is your name? (case sensitive):
    Type 'exit' to return to main menu"
    passenger_name = gets.chomp
    if passenger_name == 'exit'
      tty_command_list
    else
      puts "
      What is your Phone Number?:
      Type 'exit' to return to main menu"
      passenger_phone = gets.chomp
      if passenger_phone == 'exit'
        tty_command_list
      elsif Passenger.find_by(phone: passenger_phone) != nil
        puts "Phone Number already registered."
        tty_command_list
      else
        Passenger.create(name: passenger_name, phone: passenger_phone)
        puts "You have been successfully entered into the system!"
        tty_command_list
      end
    end
  end

  #18
  #- deletes a driver from database
  def delete_driver
    prompt = TTY::Prompt.new
    puts "
    Deleting a DRIVER from database.
    What is the License Plate of driver?
    Type 'exit' to return to main menu"
    license_plate_input = gets.chomp
    if license_plate_input == 'exit'
      tty_command_list
    else
      driver = Driver.find_by(plates: license_plate_input)
      if driver == nil
        puts "Invalid License Plate. Not in database. Please try again."
        delete_driver
      else
        confirm = prompt.yes?("Are you sure you want to delete #{driver.name}?")
        case confirm
        when true
          driver.destroy
          puts "Driver deleted from database."
          tty_command_list
        when false
          puts "Deletion Aborted"
          puts "Returning to main menu.."
          tty_command_list
        end
      end
    end
  end

  #19
  #- deletes a passenger from database
  def delete_passenger
    prompt = TTY::Prompt.new
    puts "
    Deleting a PASSENGER from database.
    What is the Phone Number of passenger?
    Type 'exit' to return to main menu"
    phone_input = gets.chomp
    if phone_input == 'exit'
      tty_command_list
    else
      passenger = Passenger.find_by(phone: phone_input)
      if passenger == nil
        puts "Invalid Phone Number. Not in database. Please try again."
        delete_passenger
      else
        confirm = prompt.yes?("Are you sure you want to delete #{passenger.name}?")
        case confirm
        when true
          passenger.destroy
          puts "Passenger deleted from database."
          tty_command_list
        when false
          puts "Deletion Aborted"
          puts "Returning to main menu.."
          tty_command_list
       end
     end
    end
  end

  #
  # - method to calculate the average trip rating of a driver.
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
