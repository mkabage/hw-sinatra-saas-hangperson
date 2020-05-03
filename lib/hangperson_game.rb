class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  
  
  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
  end

  def guess(word)
    word.downcase! unless word.nil?

    raise ArgumentError.new("Expected a letter") if invalid?(word)

    return false  if repeated_word?(word)
    if (@word.include? word)
      @guesses += word
    else
      @wrong_guesses += word
    end
    true
  end

  def check_win_or_lose
    if (@word.chars.uniq.sort == @guesses.chars.sort)
      :win
    elsif @wrong_guesses.size == 7
      :lose
    else
      :play
    end
  end

  def word_with_guesses
    redacted = @word.chars.map do |char|
      char = @guesses.include?(char) ? char : '-' 
    end
    redacted.join('')
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

  private

  def invalid?(word)
    word.nil? || word.ord < 97 || word.ord > 122
  end

  def repeated_word?(word)
    @guesses.include?(word) || @wrong_guesses.include?(word) || word.nil?
  end
end
