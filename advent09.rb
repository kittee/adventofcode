# Advent of Code
# Day 9
# Original problem: http://adventofcode.com/day/9

require_relative "utility"
require "pry"

input = get_input(9)

# Get each distance string and each city
distance_strings = input.split("\n")
cities = input.scan(/[A-Z]\w+/).uniq

# Create a hash for the distances
distances = {}

# Add each city as a key in the distances hash.
# Each city's value is also a hash.
cities.each do |city|
  distances[city] = {}
end

# Loop through the distance strings, get the distance between two cities, and
# add that value to the distances hash. We are adding it twice so it doesn't
# matter what order you look up cities in. For example, looking up
# distances["Tambi"]["Snowdin"] or distances["Snowdin"]["Tambi"] both work.
distance_strings.each do |distance|
  city1, city2 = distance.scan(/[A-Z]\w+/)
  length = distance[/[0-9]+/].to_i
  
  distances[city1][city2] = length
  distances[city2][city1] = length
end

# This magic creates every combination of cities.
routes = cities.permutation.to_a

# Create a hash to hold all the distance calculations
total_distances = {}

# Loop through all the routes to measure how long they are
routes.each do |route|
  total_distance = 0
  
  # Loop through each route's cities, then take that city and the following
  # city and look up the distance. Add that distance to the total for this
  # route. But stop looping once we reach the last city (since there is no
  # city after it).
  route.each_with_index do |city1, index|
    break if index + 1 == route.count
    city2 = route[index + 1]
    total_distance += distances[city1][city2]
  end
  
  # Once we've added up all the distances for this route, add the route and
  # total_distance as a key/value pair to the total_distances hash.
  #
  # We don't actually need the route to solve the puzzle, but it's fun to see
  # what it is.
  total_distances[route] = total_distance
end

# Sort the total_distances hash by the values, which converts it into an array.
sorted_total_distances = total_distances.sort_by {|route, distance| distance}

# Set the shortest and longest routes. These are arrays where the first element
# is an array of the cities and the second element is the distance.
shortest_route = sorted_total_distances.first
longest_route = sorted_total_distances.last

# Outputs the cities separated by arrows
#
# cities - an array of city strings
def output_cities(cities)
  puts "Cities traveled:"
  
  cities.each_with_index do |city, index|
    print city
    last_city = index + 1 == cities.count
    last_city ? (puts "\n") : (print " -> ")
  end
end

puts "Shortest route: " + shortest_route[1].to_s
output_cities(shortest_route[0])

puts "-" * 20

puts "Longest route: " + longest_route[1].to_s
output_cities(longest_route[0])