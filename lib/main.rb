require_relative 'game.rb'
require_relative 'player.rb'
require_relative 'board.rb'
require_relative 'display.rb'
require 'yaml'




def get_player_names(num_players)
  names = []
  num_players.times do |num|
    get_player_name_message(num + 1)
    names << gets.chomp
  end
  names
end

def get_player_name_message(num)
  puts
  puts "Hello, player #{num}"
  puts 'Please type your name:'
  puts
end


def load_or_new_game
  # player_names = get_player_names(2)
  player_names = ['dany', 'boss']
  player_one = ChessPlayer.new(:white, player_names[0])
  player_two = ChessPlayer.new(:black, player_names[1])
  board = ChessBoard.new
  puts 'Do you want to continue were you left or start a new one?'
  input = gets.chomp
  if input == 'new'
    game = ChessGame.new(board, player_one, player_two)
    game.play
  else
    path = 'games.yaml'
    chess_game = ChessGame.load_game(path)
    chess_game.play
  end
end

load_or_new_game
