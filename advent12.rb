# Advent of Code
# Day 12
# Original problem: http://adventofcode.com/day/12

require_relative "utility"
require "json"

input = get_input(12)

json = JSON.parse(input)

@total = 0
@total2 = 0

def add_items(item)
  if item.class == Array
    item.each do |i|
      add_items(i)
    end
  elsif item.class == Hash
    item.each do |k, v|
      add_items(v)
    end
  elsif item.class == Fixnum
    @total += item
  end
end

def add_items_without_red(item)
  if item.class == Array
    item.each do |i|
      add_items_without_red(i)
    end
  elsif item.class == Hash && !item.has_value?("red")
    item.each do |k, v|
      add_items_without_red(v)
    end
  elsif item.class == Fixnum
    @total2 += item
  end
end

add_items(json)
add_items_without_red(json)

puts @total
puts @total2