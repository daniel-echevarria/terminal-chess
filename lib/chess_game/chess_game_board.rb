require_relative '../chess_pieces/chess_rook.rb'
require_relative '../chess_pieces/chess_knight.rb'
require_relative '../chess_pieces/chess_bishop.rb'
require_relative '../chess_pieces/chess_queen.rb'
require_relative '../chess_pieces/chess_king.rb'
require_relative '../chess_pieces/chess_pawn.rb'
require_relative '../chess_game/move_generator.rb'

class ChessBoard
  # A Hash containing the info for setting up the major pieces as the game starts
  # the unicodes array follow the convention black unicode first (but it appears white on my terminal somehow)
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
    },
    bishops: {
      constructor: ChessBishop,
      positions: [[0, 2], [0, 5], [7, 2], [7, 5]],
      unicodes: ["\u265D", "\u2657"]
    },
    queens: {
      constructor: ChessQueen,
     positions: [[0, 3], [7, 3]],
      unicodes: ["\u265B", "\u2655"]
    },
    kings: {
      constructor: ChessKing,
      positions: [[0, 4], [7, 4]],
      unicodes: ["\u265A", "\u2654"]
    },
    pawns: {
      constructor: ChessPawn,
      positions: [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7],
      [6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7]],
      unicodes: ["\u265F", "\u2659"]
    }
  }
  attr_reader :board, :pieces

  def initialize
    @board = create_board
    @pieces = create_all_pieces
  end

  # Board Related Methods

  def create_board
    Array.new(8) { Array.new(8, " ") }
  end

  def reset_board
    @board = create_board
    @pieces = create_all_pieces
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
    p "   #{('a'..'h').to_a.join('   ')}  "
    puts '   -------------------------------'
    @board.each do |row|
      puts " #{i}  #{row.join(' | ')}  #{i}"
      puts '   -------------------------------'
      i -= 1
    end
    p "   #{('a'..'h').to_a.join('   ')}  "
    puts
  end

  def update_board
    populate_board(@pieces)
    display_board
  end

  def select_piece_at(position)
    @pieces.find { |piece| piece.position == position }
  end

  def move_piece(piece, position)
    snack_piece_at(position) if has_oponent?(piece, position)
    piece.position = position
  end

  def snack_piece_at(position)
    piece = select_piece_at(position)
    @pieces.delete(piece)
  end

  def position_is_free?(position)
    positions = @pieces.map(&:position)
    !positions.include?(position)
  end

  def has_oponent?(moving_piece, position)
    piece = select_piece_at(position)
    return false if piece.nil?

    piece.color != moving_piece.color
  end

  def has_ally?(moving_piece, position)
    piece = select_piece_at(position)
    return false if piece.nil?

    piece.color == moving_piece.color
  end

  def is_out_of_board?(position)
    row, col = position
    row.between?(0, 7) && col.between?(0, 7) ? false : true
  end

  def select_opponent_pieces(piece)
    opponent_pieces = @pieces.select { |p| p.color != piece.color }
  end

  def get_opponent_possible_moves(king)
    opponent_possible_moves = []
    opponent_pieces = select_opponent_pieces(king)
    opponent_pieces.each do |piece|
      mover = MoveGenerator.new(piece, self)
      opponent_possible_moves << mover.generate_possible_moves
    end
    opponent_possible_moves.flatten(1)
  end

  def is_check?(king)
    opp_possibles_moves = get_opponent_possible_moves(king)
    opp_possibles_moves.include?(king.position)
  end
  # Inital Pieces Setup

  def create_one_type_of_pieces(hash)
    constructor = hash[:constructor]
    positions = hash[:positions]
    unicodes = hash[:unicodes]

    pieces = positions.map do |pos|
      color = assign_piece_color(pos)
      unicode = assign_piece_unicode(color, unicodes)
      constructor.new(pos, color, unicode)
    end
  end

  def assign_piece_color(position)
    row = position[0]
    row < 3 ? 'black' : 'white'
  end

  def assign_piece_unicode(color, unicodes)
    color == 'white' ? unicodes[0] : unicodes[1]
  end

  def create_all_pieces
    pieces = []
    MAJOR_PIECES_INITIAL_SETUP.values.each do |type|
      pieces << create_one_type_of_pieces(type)
    end
    pieces.flatten(1)
  end
end

