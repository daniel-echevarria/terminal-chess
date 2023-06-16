
class ChessPiece

  attr_accessor :position, :color, :unicode

  def initialize(position, color, unicode = 'piece')
    @position = position
    @color = color
    @unicode = unicode
  end
end
