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

def load_or_new_input(path)
  loop do
    puts 'Do you want to continue your saved game or start a new one?'
    input = gets.chomp
    saved_game_path = 'saved_game.yaml'
    return create_new_game if %w[new n 'new one'].include?(input.downcase)
    return ChessGame.load_game(saved_game_path) if %w[saved s].include?(input.downcase) && saved_game_path

    puts 'Please type n or new for a new game or s or saved for the saved game'
  end
end


def replay_request
  puts 'Well done! do you wanna play again?'
  puts 'Y/N'
  loop do
    input = gets.chomp
    return true if input.downcase == 'y'
    return false if input.downcase == 'n'

    puts 'Please type Y for yes or N for no'
  end
end

def load_or_new_game
  saved_game_path = 'saved_game.yaml'
  return create_new_game.play unless File.exist?(saved_game_path)

  game = load_or_new_input(saved_game_path)
  game.play
end

keep_going = true
while keep_going
  load_or_new_game
  keep_going = replay_request
end
