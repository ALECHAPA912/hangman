class Board

  attr_reader :word, :health, :display

  def initialize
    @word = word_selector
    @tries = []
    @display = Array.new(@word.length, "-")
    @health = 7
  end

  def newGame
    greetings
    while @health > 0 && word != @display.join('')
      puts @display.join('')
      puts "#{@health} lives remaining"
      print "Letters tried: #{@tries}\n"
      puts "Insert a new character (a-Z)"
      try = gets.chomp.upcase
      newTry(try)
      @display = display_generator
    end
    if word == @display.join('')
      puts "YOU WON!"
    else puts "YOU LOOSE!"
    end
    puts "THE WORD WAS #{@word}"
  end

  def greetings
    puts "WELCOME TO ALEJANDRO'S HANGMAN GAME!"
  end

  def word_selector
    options = []
    words = File.open("lib/google-10000-english-no-swears.txt", "r") do |file|
      file.each do |word|
        clear_word = word.gsub("\n", "") 
        if clear_word.length > 4 && clear_word.length < 13
          options << clear_word
        end
      end
    end
    options.sample.upcase
  end

  def display_generator 
    @word.split('').each_with_index do |char, index|
      if @display[index] == "-"
        @tries.each do |try|
          if try == char
            @display[index] = try
          end
        end
      end
    end
    @display
  end

  def newTry(char)
    if !@tries.include?(char)
      @tries << char
    end
    if !@word.include?(char)
      @health -= 1
    end
  end

end