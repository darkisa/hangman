class HangpersonGame

  attr_accessor :word, :guesses, :wrong_guesses, :word_with_guesses 
  
  def initialize(word)
    @word = word 
    @guesses = "" # tracks correct letter guesses
    @wrong_guesses = "" # tracks incorrect letter guesses
    @word_with_guesses = "" # tracks the correctly guessed letters
    1.upto(word.split("").count) { @word_with_guesses += "-" }
    @attempts = 1 # tracks the number of attempts
  end

  # Function gets a letter from the user and checks if its a correct guess.
  # The user must guess the word within 7 tries or else he/she will lose
  def guess(letter)
    # STEP 1: check to make sure the letter is not any non-letter character and
    # raises an error if it is
    if /^[a-zA-Z]+$/.match(letter)
      letter.downcase!
    else raise_error("Invalid letter")
    end

    # STEP 2: check to make sure the user does not guess the same letter more
    # than once
    if @guesses.include? letter; return false; end
    if @wrong_guesses.include? letter; return false; end

    # STEP 3: check to see if the guessed letter matches any letters in the 
    # word
    if @word.include? letter
        @guesses += letter
        # if there is a match, update the word_with_guesses to show where
        # in the string the letter was matched
        @word.each_char.with_index do |c, i|
          if c == letter
            @word_with_guesses[i] = c
          end
        end 
    else 
      @wrong_guesses += letter
      @attempts += 1
    end
    # update the number of attempts and call the function to check if
    # the user won, lost, or continues playing
    check_win_or_lose
  end

  # function for dealing with multiple guesses at once
  def guess_several_letters(object, string)
    string.each { |letter| guess(letter) }
  end

  # function for checking if user won, lost, or continues playing
  def check_win_or_lose
    if !@word_with_guesses.include?("-")
      return :win
    elsif @word_with_guesses.include?("-") && @attempts >= 8
      return :lose
    else 
      return :play 
    end
  end

  def raise_error(e)
      raise ArgumentError.new(e)
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

end
