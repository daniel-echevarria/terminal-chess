require_relative '../lib/chess_game_move_module.rb'
require_relative '../lib/chess_game_piece.rb'

class ChessPawn < ChessPiece
  include MovePiece

  def potential_moves
    moves = []
    vertical_direction = @color == 'white' ? -1 : 1
    moves << move_vertically(@position, 2 * vertical_direction) if initial_position?(@position, @color)
    moves << move_vertically(@position, 1 * vertical_direction)
    moves
  end

  def initial_position?(position, color)
    initial_row = color == 'white' ? 6 : 1
    position[0] == initial_row
  end

  def set_unicode
    @unicode = @color == 'white' ? "\u265F" : "\u2659"
  end
end
