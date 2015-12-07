# Advent of Code
# Day 7
# Original problem: http://adventofcode.com/day/7

require "pry"
require_relative "utility"

# Test input
# input = "123 -> x
# 456 -> y
# x AND y -> d
# x OR y -> e
# x LSHIFT 2 -> f
# y RSHIFT 2 -> g
# NOT x -> h
# NOT y -> i"

input = get_input(7)

original_instructions = input.split("\n")
instructions = []
wires = {}

class Instruction
  attr_accessor :operator, :part1, :part2, :operator, :target
  
  def initialize(instruction_string)
    @target = instruction_string[/[a-z]{1,2}$/]
    operation_regex = /AND|OR|NOT|LSHIFT|RSHIFT/
    
    if instruction_string[operation_regex]
      @operator = instruction_string[operation_regex]
      @part2 = instruction_string[/[A-Z]+\s([0-9a-z]+)/, 1]
      @operator = instruction_string[operation_regex]
      
      if !instruction_string[/NOT/]
        @part1 = instruction_string[/^[0-9a-z]+/]
      end
    else
      @operator = "DIRECT"
      @part1 = instruction_string[/^[0-9a-z]+/]
    end
    
    if @part1 && @part1[/[0-9]+/]
      @part1 = @part1.to_i
    end
    
    if @part2 && @part2[/[0-9]+/]
      @part2 = @part2.to_i
    end
  end
end

original_instructions.each do |instruction|
  new_instruction = Instruction.new(instruction)
  instructions << new_instruction
  wires[instruction[/[a-z]{1,2}$/]] = nil
end

unused_instructions = instructions.dup

while !unused_instructions.empty?
  unused_instructions.each do |i|
    case i.operator
    when "DIRECT"
      if i.part1.class == Fixnum
        part1 = i.part1
      else
        part1 = wires[i.part1]
      end
      
      if part1
        wires[i.target] = part1
        unused_instructions -= [i]
      end
    when "AND", "OR", "LSHIFT", "RSHIFT"
      if i.part1.class == Fixnum
        part1 = i.part1
      else
        part1 = wires[i.part1]
      end
      
      if i.part2.class == Fixnum
        part2 = i.part2
      else
        part2 = wires[i.part2]
      end
      
      if part1 && part2
        case i.operator
        when "AND"
          wires[i.target] = (part1 & part2)
        when "OR"
          wires[i.target] = (part1 | part2)
        when "LSHIFT"
          wires[i.target] = (part1 << part2)
        when "RSHIFT"
          wires[i.target] = (part1 >> part2)
        end
        
        unused_instructions -= [i]
      end
    when "NOT"
      if i.part2.class == Fixnum
        part2 = i.part2
      else
        part2 = wires[i.part2]
      end
      
      if part2
        wires[i.target] = 65536 + ~part2
        unused_instructions -= [i]
      end
    end
  end
end

# Output a table of all wires and their signals
#
# I like how I spent a lot of time making this look nice rather than
# refactoring the actual logic. >_> It's the front-end dev in me.
count = 0

cell_length = 12
cells_per_row = 8
row_length = cell_length * cells_per_row + (cells_per_row + 1)

divider = "\n" + "-" * row_length

puts divider
print "|"

wires.sort.each do |wire, signal|
  output = " " + wire.to_s + ": " + signal.to_s
  padding = " " * (cell_length - output.length)
  
  print output + padding + "|"
  count += 1
  
  if count == cells_per_row
    puts divider
    print "|"
    count = 0
  end
end

if count != 0
  cells_left = cells_per_row - count
  end_padding = " " * (cells_left * cell_length + cells_left - 1)
  print end_padding + "|"
end

puts divider + "\n\n"

# Outputs just the answer
puts "Signal on Wire \"a\": " + wires["a"].to_s