

class ChessBoard

  def initialize
    @board = create_board
  end

  def create_board
    Array.new(8) { Array.new(8) }
  end
end
