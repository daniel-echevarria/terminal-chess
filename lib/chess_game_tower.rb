require_relative '../lib/chess_game_move_module.rb'

class ChessTower
  include MovePiece

  attr_reader :unicode, :color, :position

  def initialize(position, color)
    @position = position
    @color = color
    @unicode = set_unicode
  end

  def potential_moves

  end

  def list_up_vertical_moves
    row, col = @position
    last_row = 0
    next_row = row - 1
    moves = []
    for i in next_row.downto(last_row)
      moves << [i, col]
    end
    moves
  end


  def set_unicode
    @color == 'white' ? "\u265C" : "\u2656"
  end

end
