# Advent of Code
# Day 5
# Original problem: http://adventofcode.com/day/5

require_relative "utility"

input = get_input(5)

list = input.split("\n")
nice = 0
nice2 = 0

list.each do |word|
  # Part 1 requirements
  # - Contains at least 3 vowels
  # - Contains 2 of the same character in a row
  # - Does NOT contain "ab", "cd", "pq", or "xy"
  
  # Original solution with 3 regexes
  # if word.scan(/[aeiou]/).count >= 3 && word[/(.)\1/] && !word[/ab|cd|pq|xy/]
  #   nice += 1
  # end
  
  # New solution condensed to 1 regex
  if word[/^(?=.*[aeiou].*[aeiou].*[aeiou])(?=.*(.)\1)(?!.*(?:ab|cd|pq|xy)).*$/]
    nice += 1
  end
  
  # Part 2 requirements
  # - Has 2 of the same 2 characters together anywhere in the word
  # - Has 1 character that repeats with 1 character in between
  
  # Original solution with 2 regexes
  # if word[/(..).*\1/] && word[/(.).\1/]
  #   nice2 += 1
  # end
  
  # New solution condensed to 1 regex
  if word[/^(?=.*(..).*\1)(?=.*(.).\2).*$/]
    nice2 +=1
  end
end

puts "Nice list 1: " + nice.to_s
puts "Nice list 2: " + nice2.to_s