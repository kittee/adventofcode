# Advent of Code
# Day 13
# Original problem: http://adventofcode.com/day/13

require_relative "utility"

input = get_input(13)

# Calculates the best seating arrangement for people around a table
#
# names - an array of just everyone's names
# people - a multidimentional hash of how happy a person is seating next to
#          another person. For example, people["Alice"]["Bob"] has a value
#          of -57, meaning Alice loses 57 happiness sitting next to Bob.
#
# Returns an array the best seating arrangement, where the first object is an
# array of how people should be places next to each other, and the second
# object is an integer indicating the total happiness.
def find_best_arrangement(names, people)
  # Creates every combination of seating arrangements
  seating_arrangements = names.permutation.to_a

  # Create a hash to hold all the happiness calculations
  seating_arrangements_with_happiness = {}

  # Loop through seating arrangements to determine the total happiness
  seating_arrangements.each do |arrangement|
    total_happiness = 0
  
    # Loop through each name in the seating arrangement and determine how happy
    # they are sitting to the following person, and vice versa.
    arrangement.each_with_index do |name1, index|
      next_index = (index + 1 == arrangement.count ? 0 : index + 1)
      name2 = arrangement[next_index]
      total_happiness += people[name1][name2] + people[name2][name1]
    end
  
    # Once we've added up all the happiness for this seating arrangement, add
    # the seating arrangement and total_happiness as a key/value pair to the
    # seating_arrangements_with_happiness hash.
    #
    # We don't actually need the seating arrangement to solve the puzzle, but
    # it's fun to see what it is.
    seating_arrangements_with_happiness[arrangement] = total_happiness
  end

  # Sort the total_happinesses hash by the values, which converts it into an array.
  sorted_seating_arrangements = seating_arrangements_with_happiness.sort_by {|arrangement, happiness| happiness}

  # Return the best seating arrangement
  sorted_seating_arrangements.last
end

# Outputs the seating arrangement names
#
# cities - an array of city strings
def output_seating_arrangement_names(arrangement)
  puts "Seating arrangement:"
  
  arrangement.each do |name|
    print name + " - "
  end
  
  print arrangement[0] + "\n"
end

#-----------------------------------------------------------------------------#

# Part 1

# Get each string of people combinations and each name
people_strings = input.split("\n")
names = input.scan(/[A-Z]\w+/).uniq

# Create a hash for the combinations of people
people = {}

# Add each name as a key in the people hash.
# Each name's value is also a hash.
names.each do |name|
  people[name] = {}
end

# Iterate through each combination of people and determine how happy person1
# feels next to person2. Add that value to the people hash.
people_strings.each do |combo|
  person1, person2 = combo.scan(/[A-Z]\w+/)
  happiness = combo[/[0-9]+/].to_i
  
  # If the word "lose" is in the combo, make "happiness" a negative number.
  happiness *= -1 if combo[/\slose\s/]
  
  people[person1][person2] = happiness
end

# Calculate the best seating arrangement
best_seating_arrangement = find_best_arrangement(names, people)

puts "Optimal Seating Arrangement Happiness: " + best_seating_arrangement[1].to_s
output_seating_arrangement_names(best_seating_arrangement[0])

#-----------------------------------------------------------------------------#

# Part 2
# Now to add myself to this insanity

# Duplicate the names and people, and add "Myself" to the names
names2 = names.dup
people2 = people.dup
names2 << "Myself"

# Add "Myself" to the people2 hash
people2["Myself"] = {}

# Add values of 0 for happiness involving myself
# (wow that sounds weird)
people2.each do |person, others|
  others["Myself"] = 0
  people2["Myself"][person] = 0
end

# Calculate the best seating arrangement where I am seated as well
best_seating_arrangement2 = find_best_arrangement(names2, people2)

puts "-" * 20
puts "Optimal Seating Arrangement Happiness (with myself seated): " + best_seating_arrangement2[1].to_s
output_seating_arrangement_names(best_seating_arrangement2[0])