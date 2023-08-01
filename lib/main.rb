require_relative 'game.rb'
require_relative 'player.rb'
require_relative 'board.rb'

player_one = ChessPlayer.new(:white, 'Bruna')
player_two = ChessPlayer.new(:black, 'Daniel')
board = ChessBoard.new

chess_game = ChessGame.new(board, player_one, player_two)

chess_game.play
