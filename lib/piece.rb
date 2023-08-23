
class ChessPiece
  attr_accessor :specie, :position, :color, :unicode

  def initialize(specie, position, color, unicode = 'piece')
    @specie = specie
    @position = position
    @color = color
    @unicode = unicode
  end

  def winable_piece?
    @specie == :queen || @specie == :rook || @specie == :pawn
  end

  def pawn_on_promotion_position?
    return unless @specie == :pawn

    current_row = @position[0]
    promotion_row = @color == :white ? 0 : 7

    current_row == promotion_row
  end

  def pawn_on_initial_position?
    return unless @specie == :pawn

    current_row = @position[0]
    initial_row = @color == :white ? 6 : 1

    current_row == initial_row
  end
end
