# Utility methods for Advent of Code problems

# Gets the input for a given day
# Input files must go in the "inputs" directory and be named "adventXX.txt"
# where "XX" is the day with leading zeros
#
# day - an integer indicating which day's input to retrieve
#
# Returns a string of the input for that day
def get_input(day)
  # Converts the day integer to a two-character string
  # with leading zeros (if necessary)
  formatted_day = "%02d" % day
  
  file = File.open("inputs/advent" + formatted_day + ".txt", "r")
  input = file.read
  file.close
  
  input
end