require_relative '../config/environment'

@cli = CommandLineInterface.new
@ttycli = CliTty.new

def run
  puts "
                  ~~~~     __    _
    ~~~                   / l    \~-_
                  ,----~~~~--+-----`--~----_______
          ~~~     @   /~_~\  | ~      |   /~_~\~~~-\,
                  \_ ( (_) )  \_______|  ( (_) )_-~/
  ~~~~~             ~~\___/~~~~~~~~~~~~~~~\___/~

  "
#  illustration by: John Punshon
  puts "Welcome to 2Fast4Ratings! The app database that connects passengers to drivers!"
  puts "How can we help you?"
  @ttycli.tty_command_list
end

run

# prompt.select("Select a command.") do |menu|
#   menu.choice name: 'Find a Driver'
#   menu.choice name: 'Find a Passenger'
#   menu.choice name: 'Create a Trip'
#   menu.choice name: 'Delete a Trip'
#   menu.choice name: 'Give/Change a rating for a trip'
# end
