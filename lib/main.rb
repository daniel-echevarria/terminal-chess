require_relative 'game.rb'
require_relative 'player.rb'
require_relative 'board.rb'
require_relative 'display.rb'


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


# player_names = get_player_names(2)
player_names = ['Daniel', 'Bruna']

board = ChessBoard.new
player_one = ChessPlayer.new(:white, player_names[0])
player_two = ChessPlayer.new(:black, player_names[1])

chess_game = ChessGame.new(board, player_one, player_two)

chess_game.play
