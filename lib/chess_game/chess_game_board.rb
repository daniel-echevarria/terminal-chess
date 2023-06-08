
require_relative '../chess_pieces/chess_rook.rb'
require_relative '../chess_pieces/chess_knight.rb'
require_relative '../chess_pieces/chess_bishop.rb'
require_relative '../chess_pieces/chess_queen.rb'
require_relative '../chess_pieces/chess_king.rb'
require_relative '../chess_pieces/chess_pawn.rb'

class ChessBoard

  attr_reader :board

  MAJOR_PIECES_INITIAL_SETUP = {
    rooks: {
      constructor: ChessRook,
      positions: [[0, 0], [0, 7], [7, 0], [7, 7]],
      unicodes: ["\u265C", "\u2656"]
    },
    knights: {
      constructor: ChessKnight,
      positions: [[0, 1], [0, 6], [7, 1], [7, 6]],
      unicodes: ["\u265E", "\u2658"]
    }
    bishops: {
      constructor: ChessBishop,
      positions: [[0, 2], [0, 5], [7, 2], [7, 5]],
      unicodes: ["\u265D", "\u2657"]
    }
    queens: {
      constructor: ChessQueen,
      positions: [[0, 3], [7, 4]],
      unicodes: ["\u265B", "\u2655"]
    }
    kings: {
      constructor: ChessKing,
      positions: [[0, 4], [7, 5]],
      unicodes: ["\u265A", "\u2654"]
  }

  def initialize
    @board = create_board
  end

  def create_board
    Array.new(8) { Array.new(8, " ") }
  end

  def assign_piece_color(position)
    row = position[0]
    row < 3 ? 'black' : 'white'
  end

  def assign_piece_unicode(color, unicodes)
    color == 'white' ? unicodes[0] : unicodes[1]
  end

  def create_pieces(hash)
    constructor = hash[:constructor]
    positions = hash[:positions]
    unicodes = hash[:unicodes]

    pieces = positions.map do |pos|
      color = assign_piece_color(pos)
      unicode = assign_piece_unicode(color, unicodes)
      constructor.new(pos, color, unicode)
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

