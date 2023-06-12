require_relative '../../lib/chess_game/chess_game_move_module.rb'

class MoveGenerator
  include MovePiece

  attr_accessor :pieces

  def initialize(piece, board)
    @piece = piece
    @board = board
  end

  def move_piece(piece, position)
    @board.snack_piece_at(position) if @board.has_oponent?(piece, position)
    piece.position = position
  end

  def invalid_move?(position)
    @board.has_ally?(@piece, position) || @board.is_out_of_board?(position)
  end

  def generate_possible_moves
    moves = []
    piece_type = @piece.class.name
    case piece_type
    when 'ChessPawn'
      moves << generate_pawn_moves
    when 'ChessRook'
      moves << generate_rook_moves
    when 'ChessBishop'
      moves << generate_bishop_moves
    end
    moves.flatten(1)
  end

  def generate_pawn_moves
    possible_moves = []
    direction = @piece.color == 'white' ? 1 : -1
    position = @piece.position

    main_diag = move_main_diagonal(position, direction)
    sec_diag = move_secondary_diagonal(position, direction)
    one_front = move_vertically(position, direction)
    two_front = move_vertically(position, 2 * direction)

    possible_moves << main_diag if @board.has_oponent?(@piece, main_diag)
    possible_moves << sec_diag if @board.has_oponent?(@piece, sec_diag)
    possible_moves << one_front if @board.position_is_free?(one_front)
    possible_moves << two_front if @piece.on_initial_position? && @board.position_is_free?(two_front) && @board.position_is_free?(one_front)

    possible_moves
  end

  def generate_rook_moves
    moves = []

    moves << generate_moves(:up)
    moves << generate_moves(:down)
    moves << generate_moves(:left)
    moves << generate_moves(:right)

    moves.flatten(1)
  end

  def generate_bishop_moves
    moves = []

    possible_directions = [:main_diag_up, :main_diag_down, :sec_diag_up, :sec_diag_down]
    possible_directions.each { |direction| moves << generate_moves(direction) }

    p moves
    moves.flatten(1)
  end


  def generate_moves(direction, next_move = move_one(@piece.position, direction), moves = [])
    return moves if invalid_move?(next_move)
    moves << next_move
    return moves if @board.has_oponent?(@piece, next_move)

    next_move = move_one(next_move, direction)
    generate_moves(direction, next_move, moves)
  end
end
