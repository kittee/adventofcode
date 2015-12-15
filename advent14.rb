# Advent of Code
# Day 14
# Original problem: http://adventofcode.com/day/14

require_relative "utility"

input = get_input(14)
reindeer_strings = input.split("\n")

class Reindeer
  attr_accessor :name, :speed, :sprint_time, :rest_time
  
  def initialize(reindeer_string)
    @name = reindeer_string[/[A-Z]\w+/]
    @speed, @sprint_time, @rest_time = reindeer_string.scan(/[0-9]+/).map(&:to_i)
  end
  
  def calculate_distance(time)
    distance = 0
    
    while time >= @sprint_time
      distance += @speed * @sprint_time
      time -= (@sprint_time + @rest_time)
    end
    
    if time > 0
      distance += @speed * time
    end
    
    distance
  end
end

all_reindeer = []

reindeer_strings.each do |reindeer_string|
  reindeer = Reindeer.new(reindeer_string)
  all_reindeer << reindeer
end

race_time = 2503
race_results = {}

all_reindeer.each do |reindeer|
  race_results[reindeer.name] = reindeer.calculate_distance(race_time)
end

sorted_race_results = race_results.sort_by {|name, distance| distance}
winning_reindeer = sorted_race_results.last

puts "Winner by distance: " + winning_reindeer[0]
puts "Distance traveled: " + winning_reindeer[1].to_s

race_results_with_points = {}

all_reindeer.each do |reindeer|
  race_results_with_points[reindeer.name] = {"distance" => 0, "points" => 0}
end

race_time.times do |time|
  all_reindeer.each do |reindeer|
    race_results_with_points[reindeer.name]["distance"] = reindeer.calculate_distance(time)
  end
  
  sorted_race_results_with_points = race_results_with_points.sort_by {|name, stats| stats["distance"]}
  current_lead_name = sorted_race_results_with_points.last[0]
  race_results_with_points[current_lead_name]["points"] += 1
end

sorted_race_results_with_points = race_results_with_points.sort_by {|name, stats| stats["points"]}
winning_reindeer2 = sorted_race_results_with_points.last

puts "-" * 20

puts "Winner by points: " + winning_reindeer2[0]
puts "Distance traveled: " + winning_reindeer2[1]["distance"].to_s
puts "Points awarded: " + winning_reindeer2[1]["points"].to_s