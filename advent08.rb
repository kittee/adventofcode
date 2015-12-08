# Advent of Code
# Day 8
# Original problem: http://adventofcode.com/day/8

require_relative "utility"

input = get_input(8)

code_char_length = 0
actual_char_length = 0
re_encode_char_length = 0

lines = input.split("\n")

lines.each do |line|
  # Gets the length of the string as-is
  code_char_length += line.length
  
  # Gets the length of the string after escaped and special characters
  # are encoded
  actual_char_length += eval(line).length
  
  # Gets the length of the string after re-encoding all special characters
  re_encode_char_length += line.inspect.length
end

answer1 = code_char_length - actual_char_length
answer2 = re_encode_char_length - code_char_length

puts "Characters of code:                          " + code_char_length.to_s
puts "Characters in memory:                        " + actual_char_length.to_s
puts "Characters after re-encoding:                " + re_encode_char_length.to_s
puts "-" * 20
puts "SOLUTIONS"
puts "Code characters minus memory characters:     " + answer1.to_s
puts "Re-encoded characters minus code characters: " + answer2.to_s