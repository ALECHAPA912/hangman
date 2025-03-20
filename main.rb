require './lib/board.rb'
if File.exist? "saved_game.txt"
  board = Board.deserialize("saved_game.txt")
else
  board = Board.new
end

board.new_game