

class ChessBoard

  def initialize
    @board = create_board
  end

  def create_board
    Array.new(8) { Array.new(8) }
  end

  def display_board
    i = 8
    @board.each do |row|

      puts " #{i}  #{row.join(' | ')} "
      puts '   -----------------------'
      i -= 1
    end
    p "   #{('a'..'h').to_a.join('  ')}"
  end
end

chess_board = ChessBoard.new

chess_board.display_board
