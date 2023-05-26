require_relative '../lib/chess_game_move_module.rb'

class ChessPawn
  include MovePiece

  def initialize(position, color)
    @position = position
    @color = color
  end

  def possible_moves
    moves = []
    moves << move_vertically(@position, 2) if initial_position?(@position, @color)
    moves << move_vertically(@position, 1)
  end

  def initial_position?(position, color)
    initial_row = color == 'white' ? 6 : 1
    position[0] == initial_row
  end
end
