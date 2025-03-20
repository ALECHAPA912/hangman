require 'json'

class Board

  attr_accessor :word, :tries, :health, :display

  def initialize(word = word_selector, tries = [], display = Array.new(word.length, "-"), health = 7)
    @word = word
    @tries = tries
    @display = display
    @health = health
  end

  def new_game
    greetings
    while @health > 0 && word != @display.join('')
      puts @display.join('')
      puts "#{@health} lives remaining"
      print "Letters tried: #{@tries}\n"
      puts "Insert a new character (a-Z) or '912' to save game"
      try = gets.chomp.upcase
      new_try(try)
      if try == "912"
        break
      end
      @display = display_generator
    end
    if try == "912"
      serialize
      return puts "GAME SAVED!"
    elsif word == @display.join('')
      puts "YOU WON!"
    else
      puts "YOU LOOSE!"
    end
    File.delete("saved_game.txt")
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

  def new_try(char)
    if char == "912"
      return
    end
    if !@tries.include?(char)
      @tries << char
    end
    if !@word.include?(char)
      @health -= 1
    end
  end

  def serialize
    File.open("saved_game.txt", "w") do |f|
      f.puts to_json
    end
  end

  def to_json
    JSON.dump({
      :word => @word,
      :tries => @tries,
      :display => @display,
      :health => @health
    })
  end

  def self.deserialize(path)
    saved_state = from_json(File.read(path))
    self.new(saved_state["word"], saved_state["tries"], saved_state["display"], saved_state["health"]) 
  end

  def self.from_json(string)
    JSON.load string 
  end

end