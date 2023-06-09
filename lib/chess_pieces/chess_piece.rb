
class ChessPiece

  attr_accessor :position, :color, :unicode

  def initialize(position, color, unicode = 'piece')
    @position = position
    @color = color
    @unicode = unicode
  end

  def generate_possible_moves
    puts 'This class did no define the possible moves for the piece yet'
  end

end
