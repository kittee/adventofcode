# Advent of Code
# Day 4
# Original problem: http://adventofcode.com/day/4
#
# This is proooobably not what Ruby is good for.

require 'digest/md5'

input = "bgvyzdsv"
answer1 = nil
answer1_digest = nil
answer2 = nil
answer2_digest = nil
# answer3 = nil
# answer3_digest = nil
i = 1

while !answer1 || !answer2 # || !answer3
  digest = Digest::MD5.hexdigest(input + i.to_s)
  
  # This takes under a second
  if digest.start_with?("0" * 5) && !answer1
    answer1 = i
    answer1_digest = digest
  end
  
  # This took about 2 seconds
  if digest.start_with?("0" * 6) && !answer2
    answer2 = i
    answer2_digest = digest
  end
  
  # I decided to see out of curiosity how long it would take to find a digest
  # that starts with seven zeroes.
  #
  # DO NOT do this. It took like 10 minutes??
  # Which is disproportionately high considering the first two???
  #
  # if digest.start_with?("0" * 7) && !answer3
  #   answer3 = i
  #   answer3_digest = digest
  # end
  
  i += 1
end

puts "Answer 1: " + answer1.to_s
puts "The MD5 hash of " + input + answer1.to_s + " is:"
puts answer1_digest
puts "=" * 10
puts "Answer 2: " + answer2.to_s
puts "The MD5 hash of " + input + answer2.to_s + " is:"
puts answer2_digest

# puts "=" * 10
# puts "Answer 3: " + answer3.to_s
# puts "The MD5 hash of " + input + answer3.to_s + " is:"
# puts answer3_digest
#
# So I never have to do this again, this was the output:
# Answer 3: 318903846
# The MD5 hash of bgvyzdsv318903846 is:
# 000000092f8951334017b62845796ffc