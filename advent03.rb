# Advent of Code
# Day 3
# Original problem: http://adventofcode.com/day/3

require_relative "utility"

input = get_input(3)

directions = input.split("")

# Current position and list of visited coordinates for Year 1
current_position = [0, 0]
houses = [current_position.dup]

# Santa's position, Robo Santa's position, and list of visited coordinates for
# Year 2
santa_current_position = [0, 0]
robo_santa_current_position = [0, 0]
houses2 = [santa_current_position.dup, robo_santa_current_position.dup]

# Recalculates the current position and adds the new position to the
# houses array
#
# direction - a one-character string indicating the direction to move in
#             > is right, < is left, ^ is up, and v is down
# current_position - an array containing the current x and y coordinates
# houses - an array containing all visited coordinates
#
# Returns the new position after moving in the given direction
def change_position(direction, current_position, houses)
  case direction
  when ">"
    current_position[0] += 1
  when "<"
    current_position[0] -= 1
  when "^"
    current_position[1] += 1
  when "v"
    current_position[1] -= 1
  end
  
  houses << current_position.dup
  current_position
end

# Loop through the directions
directions.each.with_index do |d, i|
  # Builds the list of visited coordinates and adjusts the current position for
  # Year 1
  current_position = change_position(d, current_position, houses)
  
  # Builds the list of visited coordinates and adjusts Santa's and Robo Santa's
  # positions for Year 2. If the index of the direction is even, move Santa,
  # else move Robo Santa.
  if i.even?
    santa_current_position = change_position(d, santa_current_position, houses2)
  else
    robo_santa_current_position = change_position(d, robo_santa_current_position, houses2)
  end
end

# Removes duplicate coordinates to determine all visited houses
unique_houses = houses.uniq
unique_houses2 = houses2.uniq

puts "Houses visited in Year 1: " + unique_houses.count.to_s
puts "Houses visited in Year 2: " + unique_houses2.count.to_s