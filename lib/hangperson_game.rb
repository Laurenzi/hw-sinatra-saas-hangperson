class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service
  
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses

  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end
  
  # Make a guess in the game
  def guess(letter)
    is_letter = /^[a-zA-Z]$/
    if letter.nil? or letter.empty? or not letter.match(is_letter)
      throw ArgumentError 
    end
    letter.downcase!
    if self.guesses.include? letter or self.wrong_guesses.include? letter
      return false
    end
    if self.word.include? letter
      self.guesses = self.guesses + letter
    else
      self.wrong_guesses = self.wrong_guesses + letter
    end
    return true
  end
  
  # Display word with guesses
  def word_with_guesses
    word_to_display = ''
    self.word.chars do |letter|
      # if we find letter in the word to be in guessed letters
      # replace it with the actual letter
      if self.guesses.include? letter
        word_to_display += letter
      else
        word_to_display += '-'
      end
    end
    return word_to_display
  end
  
  # Check status of game - :win, :lose or :play
  def check_win_or_lose
    # if guessed letters are 7 then lose
    if self.wrong_guesses.length >= 7
      :lose
    elsif all_letters_in_word_in_guesses?
      :win
    else
      :play
    end
  end
  
  def all_letters_in_word_in_guesses?
    self.word.chars do |letter|
      if not self.guesses.include? letter
        return false
      end
    end
  end

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end
  
end
