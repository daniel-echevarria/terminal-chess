require_relative 'game.rb'
require_relative 'player.rb'
require_relative 'board.rb'

def get_player_names(num_players)
  names = []
  num_players.times do |num|
    ask_player_name_message(num)
    names << gets.chomp
  end
  names
end

def ask_player_name_message(num)
  puts
  puts "Hello, player #{num + 1}"
  puts 'Please type your name:'
  puts
end

player_names = get_player_names(2)
# player_names = ['Daniel', 'Bruna']

player_one = ChessPlayer.new(:white, player_names[0])
player_two = ChessPlayer.new(:black, player_names[1])
board = ChessBoard.new

chess_game = ChessGame.new(board, player_one, player_two)

chess_game.play
