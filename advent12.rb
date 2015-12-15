# Advent of Code
# Day 12
# Original problem: http://adventofcode.com/day/12

require_relative "utility"
require "json"

input = get_input(12)

json = JSON.parse(input)

# Class for evaluating the sums of numbers in JSON objects
class AccountingSystem
  attr_accessor :json
  
  def initialize(json)
    @json = json
  end
  
  # Adds all integer values in the system
  #
  # Returns an integer sum
  def total
    @total_count = 0
    add_items(@json)
    @total_count
  end
  
  # Adds all integer values in the system, but will ignore objects that have a
  # value of the passed data
  #
  # ignore - any value, if an object has this value, the entire object is
  #          excluded from the total
  #
  # Returns an integer sum
  def total_without(ignore)
    @total_count = 0
    add_items(@json, ignore)
    @total_count
  end
  
  private
  
  # A recursive method used in the total and total_without methods. This method
  # steps through all levels of an object and adds integers that it finds to
  # the @total_count.
  #
  # item - data of any type to evaluate
  # ignore - any value, optional, if an object has this value, the entire
  #          object is excluded from the total
  def add_items(item, ignore = nil)
    case item.class.name
    when "Array"
      item.each do |i|
        add_items(i, ignore)
      end
    when "Hash"
      # If there is nothing to ignore, or if there is something to ignore but
      # the hash does not have that value, continue calling add_items.
      if !ignore || (ignore && !item.has_value?(ignore))
        item.each do |k, v|
          add_items(v, ignore)
        end
      end
    when "Fixnum"
      @total_count += item
    end
  end
end

# Create the accounting system object
accounting_system = AccountingSystem.new(json)

# Evaluate parts 1 and 2 of the challenge
answer1 = accounting_system.total
answer2 = accounting_system.total_without("red")

puts "Total: " + answer1.to_s
puts "-" * 20
puts "Total excluding objects\nwith \"red\" values: " + answer2.to_s