#!/usr/bin/env ruby
require 'set'
require_relative 'wordle_solver'

# Prompt user to enter Wordle boxes from the last guess.
def get_wordle_row
  result = nil
  while result.nil? do
    print "Enter the Wordle result: "
    input = gets.strip
    if input.length == 5 && input.chars.to_set <= Set.new(['X', 'Y', 'G', 'N'])
      result = input
    end
  end

  result
end

def guess_and_get_result
  puts "Try this word: #{@solver.generate_guess}\n"

  row = get_wordle_row
  if row == 'GGGGG'
    puts 'Congratulations, you won!'
    exit
  end

  @solver.handle_result(row)
end


puts "Welcome to the Wordle solver!"
puts "Use the following legend to enter the colored tiles."
puts ""
puts "Gray:   X"
puts "Green:  G"
puts "Yellow: Y"
puts ""
puts "E.g. enter 'XXYGX' for a row that is gray, gray, yellow, green, gray."
puts "Use 'NNNNN' if the solver suggests an invalid word."
puts "\n"

@solver = WordleSolver.new
while true do
  guess_and_get_result
end
