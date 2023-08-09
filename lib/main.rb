require_relative 'game.rb'
require_relative 'player.rb'
require_relative 'board.rb'

NUM_PLAYERS = 2

def get_player_names(num_players)
  names = []
  num_players.times do |num|
    puts
    puts "Hello, player #{num + 1}"
    puts 'Please type your name:'
    puts
    names << gets.chomp
  end
  names
end

player_names = get_player_names(NUM_PLAYERS)

player_one = ChessPlayer.new(:white, player_names[0])
player_two = ChessPlayer.new(:black, player_names[1])
board = ChessBoard.new

chess_game = ChessGame.new(board, player_one, player_two)

chess_game.play
