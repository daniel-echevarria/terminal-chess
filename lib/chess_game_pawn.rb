require_relative '../lib/chess_game_move_module.rb'

class ChessPawn
  include MovePiece

  attr_reader :unicode, :color
  attr_accessor :position

  def initialize(position, color)
    @position = position
    @color = color
    @unicode = set_unicode
  end

  def potential_moves
    moves = []
    vertical_direction = @color == 'white' ? -1 : 1
    moves << move_vertically(@position, 2 * vertical_direction) if initial_position?(@position, @color)
    moves << move_vertically(@position, 1 * vertical_direction)
    moves << move_main_diagonal(@position, 1 * vertical_direction)
    moves << move_secondary_diagonal(@position, 1 * vertical_direction)
    moves
  end

  def initial_position?(position, color)
    initial_row = color == 'white' ? 6 : 1
    position[0] == initial_row
  end

  def set_unicode
    @color == 'white' ? "\u265F" : "\u2659"
  end
end
