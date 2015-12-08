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

#-----------------------------------------------------------------------------#

# Instruction class
# Object with information pertaining to how to connect wires
#
# operator - string indicating the operator
#
#    "EQUALS" - connect one wire/signal (operand1) directly to a wire (result)
#               e.g. Instruction: x -> y
#                    Ruby:        y = x
#
#    "AND"    - the bitwise AND of operand1 and operand2 is provided to a wire
#               e.g. Instruction: x AND y -> z
#                    Ruby:        z = x & y
#
#    "OR"     - the bitwise OR of operand1 and operand2 is provided to a wire
#               e.g. Instruction: x OR y -> z
#                    Ruby:        z = x | y
#
#    "NOT"    - the bitwise compliment of operand2 is provided to a wire
#               These wires carry a 16-bit signal (a number 0-65535), so the
#               result ends up being 65536 plus the bitwise compliment of
#               operand2 (which will be a negative number).
#               e.g. Instruction: NOT x -> y
#                    Ruby:        y = 65536 + ~x
#
#    "LSHIFT" - the value of operand1 is left-shifted by operand2 and provided
#               to a wire
#               e.g. Instruction: x LSHIFT 1 -> y
#                    Ruby:        y = x << 1
#
#    "RSHIFT" - the value of operand1 is right-shifted by operand2 and provided
#               to a wire
#               e.g. Instruction: x RSHIFT 1 -> y
#                    Ruby:        y = x >> 1
#
# operand1 - a string or integer of the first part of the instruction,
#            is not set if the operator is "NOT"
# operand2 - a string or integer of the second part of the instruction,
#            is not set if the operator is "EQUALS"
#
# operand1 and operand2 are each an integer if the instruction provided a
# signal, or a string indicating another wire if the instruction provided
# a wire
#
# e.g. For x RSHIFT 1 -> y, operand1 would be the string "x" and operand2 would
# be the integer 1.
#
# result - a string indicating the wire being connected to
class Instruction
  attr_accessor :operator, :operand1, :operand2, :result
  
  def initialize(instruction_string)
    @result = instruction_string[/[a-z]{1,2}$/]
    
    # The possible operations provided by the instruction
    operation_regex = /AND|OR|NOT|LSHIFT|RSHIFT/
    
    if instruction_string[operation_regex]
      @operator = instruction_string[operation_regex]
      
      # Matches the operand after the operation
      @operand2 = instruction_string[/[A-Z]+\s([0-9a-z]+)/, 1]
      
      if !instruction_string[/NOT/]
        # Matches the operand at the start of the instruction
        @operand1 = instruction_string[/^[0-9a-z]+/]
      end
    else
      # If the operation_regex did not match, this instruction must be
      # connecting one wire/signal directly into a wire
      @operator = "EQUALS"
      @operand1 = instruction_string[/^[0-9a-z]+/]
    end
    
    # Convert number strings to integers if they were a signal rather than a
    # wire label.
    @operand1, @operand2 = [@operand1, @operand2].map do |op|
      op && op[/[0-9]+/] ? op.to_i : op
    end
  end
end

# Sets an operand. If the operand is an integer, use it, else if it's a string,
# grab the value of the wire in the wires hash using the operand as a key. If
# the wire's signal has not been set yet in the wires hash, this method will
# return nil.
#
# operand - an integer or string indicating either a signal or a wire,
#           respectively
# wires - a hash of the wires' labels and signals
#
# Returns an integer, or nil if the provided operand was a string and the
# wire's signal has not been set yet in the wires hash.
def set_operand(operand, wires)
  if operand.class == Fixnum
    operand
  else
    wires[operand]
  end
end

# Connects wires using the instructions.
#
# This method will attempt to set wires to integers (their signals). For
# example, 0 -> c will set wires["c"] = 0.
#
# If a provided operand is another wire, we will try to look up if that wire's
# signal has been determined yet in the wires hash. For example,
# x LSHIFT 2 -> y will attempt to look up if wires["x"] has been solved yet. If
# it hasn't, skip this instruction and try again later after evaluating all
# other instructions. If it has, do math according to the operator and set the
# wire's value to the result.
#
# Once an instruction is successfully completed, remove it from the
# instructions array. Keep removing instructions until they are all resolved.
#
# instructions - an array of Instruction objects indicating how to
#                connect wires
#
# Returns a hash with strings representing wires as the keys, and integers
# representing signals as the values
def connect_wires(instructions)
  wires = {}
  
  # Keep looping until all instructions have been used
  while !instructions.empty?
    instructions.each do |i|
      case i.operator
      when "EQUALS"
        operand1 = set_operand(i.operand1, wires)
      
        if operand1
          wires[i.result] = operand1
        end
      when "AND", "OR", "LSHIFT", "RSHIFT"
        operand1 = set_operand(i.operand1, wires)
        operand2 = set_operand(i.operand2, wires)
      
        if operand1 && operand2
          case i.operator
          when "AND"
            wires[i.result] = (operand1 & operand2)
          when "OR"
            wires[i.result] = (operand1 | operand2)
          when "LSHIFT"
            wires[i.result] = (operand1 << operand2)
          when "RSHIFT"
            wires[i.result] = (operand1 >> operand2)
          end
        end
      when "NOT"
        operand2 = set_operand(i.operand2, wires)
      
        if operand2
          wires[i.result] = 65536 + ~operand2
        end
      end
      
      # Remove the instruction if it was sucessfully executed
      if wires[i.result]
        instructions -= [i]
      end
    end
  end
  
  wires
end

#-----------------------------------------------------------------------------#

# Finally, the flow can begin

original_instructions = input.split("\n")
instructions = []

# Loop through the instruction strings and construct Instruction objects.
original_instructions.each do |instruction|
  new_instruction = Instruction.new(instruction)
  instructions << new_instruction
end

# Set all the wires' signals for part 1
wires = connect_wires(instructions)

# For part 2, start completely over, but this time, wire "b"'s signal is the
# result of wire "a" from part 1. So we'll duplicate the instructions and
# rewrite the "b" instruction.
instructions2 = instructions.dup
b_instruction = instructions2.find {|i| i.result == "b"}
b_instruction.operand1 = wires["a"]
b_instruction.operator = "EQUALS"

# Set all the wires' signals for part 2
wires2 = connect_wires(instructions2)

#-----------------------------------------------------------------------------#

# Outputs a table of wires and their signals.
# The front-end dev in me was compelled to make this look nice.
#
# wires - a hash of the wires
# title - a string for the title above the table
def make_wires_table(wires, title)
  count = 0
  
  # Set the cell size and cells per row
  cell_length = 12
  cells_per_row = 8
  dividers_num = cells_per_row + 1
  row_length = cells_per_row * cell_length + dividers_num

  divider = "\n" + "-" * row_length
  
  puts "\n\n" + title
  puts divider
  print "|"
  
  # Loops through the wires and puts one wire per cell
  wires.sort.each do |wire, signal|
    output = " " + wire + ": " + (wire.length == 1 ? " " : "") + signal.to_s
    padding = " " * (cell_length - output.length)
  
    print output + padding + "|"
    count += 1
  
    if count == cells_per_row
      puts divider
      print "|"
      count = 0
    end
  end
  
  # If the wires did not divide evenly by the cells_per_row, add some padding
  # to the last row of the table and close it
  if count != 0
    cells_left = cells_per_row - count
    end_padding = " " * (cells_left * cell_length + cells_left - 1)
    print end_padding + "|"
  end

  puts divider + "\n\n"
end

# Outputs all the wires
make_wires_table(wires, "PART 1")
make_wires_table(wires2, "PART 2")

# Outputs just the answer
puts "Signal on wire \"a\", part 1: " + wires["a"].to_s
puts "Signal on wire \"a\", part 2: " + wires2["a"].to_s