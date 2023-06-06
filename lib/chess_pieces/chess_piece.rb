
class ChessPiece

  attr_accessor :position, :color, :unicode

  def initialize(position, color)
    @position = position
    @color = color
    @unicode = set_unicode
  end
end
