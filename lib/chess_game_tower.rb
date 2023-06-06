require_relative '../lib/chess_game_move_module.rb'

class ChessTower
  include MovePiece

  attr_reader :unicode, :color, :position

  def initialize(position, color)
    @position = position
    @color = color
    @unicode = set_unicode
  end

  def set_unicode
    @color == 'white' ? "\u265C" : "\u2656"
  end

end
