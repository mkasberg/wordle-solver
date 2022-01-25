class WordleSolver
  def initialize
    sorted_words = File.readlines('words_wordle.txt').map(&:strip)
    @no_duplicate_letters = sorted_words.select do |w|
      Set.new(w.chars).size == 5
    end

    @possibilities = sorted_words
    @yellow_letters = Set.new
    @guesses = []
  end

  def generate_guess
    if @guesses.size == 0
      @guesses << first_guess
    elsif @guesses.size == 1
      @guesses << second_guess
    else
      @guesses << 
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
    end

    @guesses.last
  end

  def handle_result(result)
    if result[0] == 'N'
      remove_word(@guesses.pop)
    else
      result.chars.each_with_index do |c, i|
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
  end

  private

  def first_guess
    @no_duplicate_letters.first
  end

  def second_guess
    used_letters = Set.new(first_guess.chars)

    @no_duplicate_letters.select { |w|
      !w.chars.map { |c|
        used_letters.include?(c)
      }.include?(true)
    }.first
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

end
