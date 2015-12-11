# Advent of Code
# Day 11
# Original problem: http://adventofcode.com/day/11

# This is painfully slow. It's taking about a minute to crunch both parts of
# the problem but at this moment I'm not sure where to refactor.

require_relative "utility"

input = "vzbxkghb"
password = input.dup

def increment_password(password)
  letters = password.split("")
  letter_to_change = -1
  changing_password = true
  
  while changing_password
    if letters[letter_to_change] == "z"
      letters[letter_to_change] = "a"
      
      if letter_to_change.abs == letters.count
        changing_password = false
      else
        letter_to_change -= 1
      end
    else
      letters[letter_to_change].next!
      changing_password = false
    end
  end
  
  letters.join("")
end

@alphabet_trios = []

("a".."x").to_a.each do |letter|
  @alphabet_trios << letter + letter.next + letter.next.next
end

@alphabet_trios = @alphabet_trios.join("|")

def valid_password?(password)
  no_forbidden_letters = /[^iol]/
  pairs = /(.)\1/
  
  if password[/#{@alphabet_trios}/] && password[no_forbidden_letters] && password.scan(pairs).count > 1
    true
  else
    false
  end
end

password = increment_password(password)

while !valid_password?(password)
  password = increment_password(password)
end

puts "1st password: " + password

password2 = password.dup
password2 = increment_password(password2)

while !valid_password?(password2)
  password2 = increment_password(password2)
end

puts "2nd password: " + password2