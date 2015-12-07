# Advent of Code
# Day 6
# Original problem: http://adventofcode.com/day/6

# I've got this down to about 5.3-5.5 seconds to solve both parts of the
# problem, as opposed to about a minute in the first iteration.

require "benchmark"
require_relative "utility"

input = get_input(6)

# Start of Benchmark wrapper for evaluating speed
# Uncomment this next line and the end curly brace at the bottom of the file to measure speed
# puts "\nBenchmark\n" + Benchmark.measure {

instructions = input.split("\n")

on_off_lights = []
on_lights = 0

adjustable_lights = []
total_brightness = 0

# These lights can only be on or off
class OnOffLight
  attr_accessor :on
  
  def initialize(on = false)
    @on = on
  end
  
  # Adjusts the "on" attribute of a light for a given action
  # Will set the "on" attribute to true if the light is being turned on, false
  # if it is being turned off, or will toggle the light's "on" status.
  #
  # action - string "turn on", "turn off", or "toggle"
  def adjust(action)
    # Apparently case statements evaluate more quickly than if statements in
    # this situation
    case action
    when "turn on"
      @on = true
    when "turn off"
      @on = false
    else
      @on = !@on
    end
  end
end

# These lights have a brightness range
class AdjustableLight
  attr_accessor :brightness
  
  def initialize(brightness = 0)
    @brightness = brightness
  end
  
  # Adjusts the brightness attribute of a light for a given action
  # Will increase brightness by 1 for "turn on", increase brightness by 2 for
  # "toggle", or decrease by 1 for "turn off" (but will go no lower than zero)
  #
  # action - string "turn on", "turn off", or "toggle"
  def adjust(action)
    case action
    when "turn on"
      @brightness += 1
    when "toggle"
      @brightness += 2
    else
      @brightness -= 1 if @brightness > 0
    end
  end
end

# Creates lights for the 1000x1000 grids and adds them to the light arrays.
1000000.times do
  on_off_lights << OnOffLight.new
  adjustable_lights << AdjustableLight.new
end

instructions.each do |instruction|
  action = instruction[/turn on|turn off|toggle/]

  # Scans the instruction for the four coordinates
  start_x, start_y, end_x, end_y = instruction.scan(/[0-9]{1,3}/).map(&:to_i)
  
  # Loops through each affected line on the y axis
  (start_y..end_y).each do |y|
    # Within each vertical line, loops through each affected light on the
    # x axis
    (start_x..end_x).each do |x|
      # The index of the light within the light lists is y * 1000 + x,
      # For example, a light with the coordinates 128, 98 would be indexed at
      # 98 * 1000 + 128 = 98128 in the lists. A light at 0, 11 would be indexed
      # at 0 * 1000 + 11 = 11.
      i = y * 1000 + x

      on_off_lights[i].adjust(action)
      adjustable_lights[i].adjust(action)
    end
  end
end

on_off_lights.each {|light| on_lights += 1 if light.on}
adjustable_lights.each {|light| total_brightness += light.brightness}

puts "Part 1"
puts "Lights that are on: " + on_lights.to_s
puts "-" * 10
puts "Part 2"
puts "Total brightness: " + total_brightness.to_s

# }.to_s # end Benchmark wrapper