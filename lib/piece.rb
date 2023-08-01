
class ChessPiece

  attr_accessor :specie, :position, :color, :unicode

  def initialize(specie, position, color, unicode = 'piece')
    @specie = specie
    @position = position
    @color = color
    @unicode = unicode
  end
end
