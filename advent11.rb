# Advent of Code
# Day 11
# Original problem: http://adventofcode.com/day/11

# This is down to about 20 seconds from about a minute before,
# I think that's as fast as I can get it.

require_relative "utility"

input = "vzbxkghb"
password = input.dup

# Increments a string of lowercase letters, one letter at a time, starting
# with the last letter. For example, "aaa" would become "aab".
#
# If the letter to increment is "z", loop back to "a" and increment the prior
# letter. For example, "aaz" becomes "aba". "czz" would become "daa".
#
# "i", "o", and "l" are forbidden letters, so they are always skipped over.
#
# password - a string to increment
#
# Returns the incremented string
def increment_password(password)
  forbidden_letters = /[iol]/
  
  # Increment the string
  # .next is magic omg
  password.next!
  
  # If the last character is a forbidden letter, increment again.
  if password[-1][forbidden_letters]
    password.next!
  end

  # If there are still forbidden characters that weren't at the end of the
  # string, we increment that letter and reset the following characters to "a".
  if password[forbidden_letters]
    letters = password.split("")
    change_next_letter_to_a = false

    letters.map do |letter|
      if change_next_letter_to_a
        "a"
      elsif letter[forbidden_letters]
        change_next_letter_to_a = true
        letter.next!
      end
    end

    password = letters.join("")
  end
  
  password
end

# Creates a string of alphabet trios ("abc", "bcd", etc.) to use as a
# regex in valid_password?.
@alphabet_trios = []

("a".."x").each do |letter|
  @alphabet_trios << letter + letter.next + letter.next.next
end

@alphabet_trios = @alphabet_trios.join("|")

# Validates if the password follows the rules of the puzzle
#
# Requirements:
# - Must have at least 1 alphabet trio ("abc", "bcd", etc.)
# - Must NOT have "i", "o", or "l" (which is handled in increment_password,
#   because it's faster than checking it here and sending it straight back to
#   increment_password when it doesn't pass)
# - Must have at least 2 pairs of different, non-overlapping pairs
#   (e.g. "aa" and "bb")
def valid_password?(password)
  pairs = /((.)\2)/
  
  if password[/#{@alphabet_trios}/] && password.scan(pairs).uniq.count > 1
    true
  else
    false
  end
end

# Increment the password
password = increment_password(password)

# Keep incrementing until the password is valid.
while !valid_password?(password)
  password = increment_password(password)
end

puts "1st password: " + password

# Take the answer from part 1 and repeat to generate a new password.
password2 = password.dup
password2 = increment_password(password2)

while !valid_password?(password2)
  password2 = increment_password(password2)
end

puts "2nd password: " + password2