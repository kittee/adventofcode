# Advent of Code
# Day 1
# Original problem: http://adventofcode.com/day/1

require_relative "utility"

input = get_input(1)

parentheses_list = input.split("")
current_floor = 0
first_basement_step = false

parentheses_list.each.with_index do |p, i|
  p == "(" ? current_floor += 1 : current_floor -= 1
  
  # For debugging
  # Uncomment lines 21-22 for details of each step. Example:
  # "Step 1: Up a floor"
  # "Current floor: 1"
  #
  # puts "Step " + (i + 1).to_s + ": " + (p == "(" ? "Up" : "Down") + " a floor"
  # puts "Current floor: " + current_floor.to_s + "\n\n"
  
  if current_floor == -1 && !first_basement_step
    first_basement_step = i + 1
  end
end

puts "Santa ended on floor " + current_floor.to_s
puts "Santa first reached the basement at step " + first_basement_step.to_s