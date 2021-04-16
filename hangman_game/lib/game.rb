class Game
  def initialize
    @key = generate_key
    @key_clues = ''
    @key.length.times { @key_clues << '_' }
    @guessed = []
    @guesses = 10
  end

  def request_guess
    begin
      display
      print "Enter a letter, or type save to save progress: "
      guess = gets.chomp.downcase!
      return 'save' if guess == 'save'

      raise "Invalid input: #{guess}" unless /[[:alpha:]]/.match(guess) && guess.length == 1
      raise "You've already guessed that letter!" if @guessed.include?(guess)

      enter_guess(guess)
    rescue StandardError => e
      puts
      puts e.to_s
      retry
    end
  end

  def over?
    if @key == @key_clues
      puts "You guessed the word!"
      puts @key
      puts
      true
    elsif @guesses.zero?
      puts "You couldn't guess the word!"
      puts @key
      puts
      true
    end
  end

  private

  def enter_guess(char)
    if @key.include?(char)
      @guessed << char
      add_clue(char)
      puts
      puts "Good guess!"
    else
      @guessed << char
      @guesses -= 1
      puts
      puts "No luck!"
    end
  end

  def display
    if @guesses < 10
      print "Letters guessed: "
      @guessed.each { |guess| print guess.to_s + ' ' }
      puts
    end
    if @guesses > 3
      puts "Incorrect guesses remaining: #{@guesses}"
    elsif @guesses > 1
      puts "Incorrect guesses remaining: #{@guesses}"
    else
      puts "Last chance!"
    end
    puts @key_clues
  end

  def add_clue(char)
    @key.split('').each_with_index do |v, i|
      @key_clues[i] = char if v == char
    end
  end

  def generate_key
    dictionary = File.open('../5desk.txt', 'r')
    words = []
    dictionary.each_line do |l|
      l = l.chomp
      if l.length <= 12 &&
         l.length >= 5 &&
         /[[:lower:]]/.match(l[0])
        words << l
      end
    end
    dictionary.close
    words.sample
  end
end
