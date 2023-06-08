
require_relative '../chess_pieces/chess_rook.rb'
require_relative '../chess_pieces/chess_knight.rb'
require_relative '../chess_pieces/chess_bishop.rb'
require_relative '../chess_pieces/chess_queen.rb'
require_relative '../chess_pieces/chess_king.rb'
require_relative '../chess_pieces/chess_pawn.rb'

class ChessBoard

  attr_reader :board

  MAJOR_PIECES_WITH_INITIAL_POSITIONS = {
    rooks: { constructor: ChessRook,
             positions: [[0, 0], [0, 7], [7, 0], [7, 7]]
            },
    knights: [ChessKnight, [[0, 1], [0, 6], [7, 1], [7, 6]]],
    bishops: [ChessBishop, [[0, 2], [0, 5], [7, 2], [7, 5]]],
    queens: [ChessQueen, [[0, 3], [7, 4]]],
    kings: [ChessKing, [[0, 4], [7, 5]]]
  }

  def initialize
    @board = create_board
  end

  def create_board
    Array.new(8) { Array.new(8, " ") }
  end

  # def create_pieces(piece_creator, positions)
  #   pieces = positions.map do |pos|
  #     color = pos[0] < 3 ? 'black' : 'white'
  #     piece_creator.new(pos, color)
  #   end
  # end

  # given an hash with the constructor and the positions create the pieces at the position

  def create_pieces(hash)
    constructor = hash[:constructor]
    positions = hash[:positions]
    pieces = positions.map do |pos|
      color = pos[0] < 3 ? 'black' : 'white'
      constructor.new(pos, color)
    end
  end

  def populate_board(pieces)
    pieces.each do |piece|
      row, col = piece.position
      @board[row][col] = piece.unicode
    end
  end

  def clean_cell(position)
    row, col = position
    @board[row][col] = " "
  end

  def display_board
    i = 8
    @board.each do |row|
      puts " #{i}  #{row.join(' | ')} "
      puts '   -------------------------------'
      i -= 1
    end
    p "   #{('a'..'h').to_a.join('   ')}"
  end
end

