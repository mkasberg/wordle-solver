#!/usr/bin/env ruby
require 'set'

sorted_words = File.readlines('words_wordle.txt').map(&:strip)
no_dups = sorted_words.select do |w|
  Set.new(w.chars).size == 5
end


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

def require_letter_at(letter, position)
  @possibilities.select! do |word|
    word[position] == letter
  end
end

def remove_letter_at(letter, position)
  @possibilities.select! do |word|
    word[position] != letter
  end
end

def remove_letter(letter)
  @possibilities.select! do |word|
    !word.include?(letter)
  end
end

def remove_word(word)
  @possibilities.select! do |p|
    p != word
  end
end

def check_and_guess_again
  row = get_wordle_row
  if row == 'GGGGG'
    puts 'Congratulations, you won!'
    exit
  end

  if row[0] == 'N'
    remove_word(@guesses.last)
  else
    row.chars.each_with_index do |c, i|
      if c == 'G'
        require_letter_at(@guesses.last[i], i)
      elsif c == 'Y'
        @yellow_letters << @guesses.last[i]
        remove_letter_at(@guesses.last[i], i)
      else
        if @yellow_letters.include?(@guesses.last[i])
          # Wordle will mark the first instance yellow and the second instance grey if
          # the word only contains the letter once but your guess contains it twice.
          remove_letter_at(@guesses.last[i], i)
        else
          remove_letter(@guesses.last[i])
        end
      end
    end
  end

  next_guess = 
    if @yellow_letters.size > 0
      @possibilities.select { |word|
        has_letters = @yellow_letters.map do |l|
          word.include?(l)
        end
        !has_letters.include?(false)
      }.first
    else
      @possibilities.first
    end
  @guesses << next_guess

  puts "Try this word: #{next_guess}\n"
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

@possibilities = sorted_words
puts "Try this word: #{no_dups.first}\n"
@guesses = [no_dups.first]
@yellow_letters = Set.new

while true do
  check_and_guess_again
end

