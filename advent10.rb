# Advent of Code
# Day 10
# Original problem: http://adventofcode.com/day/10

require_relative "utility"

input = "1113222113"
answer = input.clone

# Takes a string of numbers and converts it using the look-and-say method.
#
# Examples:
# "1" would be "one 1", or "11".
# "12" is "one 1, one 2", or "1112".
# "11122" is "three 1s, two 2s", or "3122".
#
# input - a string of integers to be converted
#
# Returns a string of the input after applying look-and-say
def look_and_say(input)
  # Scans the input for groups of like numbers and returns them as an array
  # of strings
  #
  # e.g. "11112223111" would return ["1111", "222", "3", "111"]
  pieces = input.scan(/((.)\2*)/).collect {|p| p[0]}
  result = ""
  
  # Loops through the pieces and adds the length of the string and the number
  # in the string to the result
  #
  # e.g. "1111" would append "4" and "1" to the result
  pieces.each {|p| result << p.length.to_s + p[0]}
  
  # Returns the result
  result
end

# Applies look-and-say 40 times for part 1
40.times {answer = look_and_say(answer)}

# Takes the answer from part 1 and applies look-and-say 10 more times for a
# total of 50 times for part 2
answer2 = answer.clone
10.times {answer2 = look_and_say(answer2)}

puts "Length of look and say 40 times: " + answer.length.to_s
puts "Length of look and say 50 times: " + answer2.length.to_s