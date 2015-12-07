# Advent of Code
# Day 2
# Original problem: http://adventofcode.com/day/2

require_relative "utility"

input = get_input(2)

present_list = input.split("\n")
wrapping_paper_needed = 0
ribbon_needed = 0

present_list.each do |present|
  # Creates an array of the dimensions, sorted smallest to largest
  dimensions = present.split("x").map(&:to_i).sort!
  
  # Creates an array of the sides, sorted smallest to largest
  sides = [
    dimensions[0] * dimensions[1],
    dimensions[0] * dimensions[2],
    dimensions[1] * dimensions[2]
  ].sort!
  
  # Wrapping paper needed is each side, plus one more of the smallest side for slack
  # e.g. A 3x11x24 present needs 3*(3*11) + 2*(3*24) + 2*(11*24) = 771 sq feet
  wrapping_paper_needed += 3 * sides[0] + 2 * sides[1] + 2 * sides[2]
  
  # Ribbon needed is the perimeter of the smallest side plus the result of the volume
  # e.g. A 3x11x24 present needs 2*3 + 2*11 + 3*11*24 = 820 feet
  ribbon_needed += dimensions[0] * 2 + dimensions[1] * 2 + dimensions[0] * dimensions[1] * dimensions[2]
end

puts "Wrapping paper needed: " + wrapping_paper_needed.to_s + " square feet"
puts "Ribbon needed: " + ribbon_needed.to_s + " feet"