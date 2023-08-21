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

def create_new_game
  player_names = get_player_names(2)
  player_one = ChessPlayer.new(:white, player_names[0])
  player_two = ChessPlayer.new(:black, player_names[1])
  board = ChessBoard.new
  ChessGame.new(board, player_one, player_two)
end


def load_or_new_game
  saved_game_path = 'saved_game.yaml'
  return create_new_game.play unless File.exist?(saved_game_path)

  puts 'Do you want to continue were you left or start a new one?'
  input = gets.chomp
  if input.include?('new')
    game = create_new_game
    game.play
  else
    chess_game = ChessGame.load_game(saved_game_path)
    chess_game.play
  end
end

def replay_request
  puts 'Well done girls, do you wanna play again?'
  puts 'Y/N'
  loop do
    input = gets.chomp
    return false if %w[Y y].include?(input)
    return true if %w[N n].include?(input)

    puts 'Please type Y for yes or N for no'
  end
end

stop_playing = false
until stop_playing
  load_or_new_game
  stop_playing = replay_request
end

