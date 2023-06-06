require_relative '../lib/chess_game_move_module.rb'

class MoveGenerator
  include MovePiece

  attr_accessor :pieces

  def initialize(piece, board)
    @piece = piece
    @board = board
    @pieces = board.pieces
  end

  def generate_moves(piece)
  end

  def select_piece_at(position)
    piece = @pieces.select { |piece| piece.position == position }
    piece.first
  end

  def has_oponent(moving_piece, position)
    piece = select_piece_at(position)
    return false if piece.nil?

    piece.color != moving_piece.color
  end

  def has_ally(moving_piece, position)
    piece = select_piece_at(position)
    return false if piece.nil?

    piece.color == moving_piece.color
  end

  def is_out_of_board?(position)
    row, col = position
    row.between?(0, 7) && col.between?(0, 7) ? false : true
  end

  def generate_up_vertical_moves(piece, next_move = move_vertically(piece.position, -1), moves = [])
    return moves if has_ally(piece, next_move) || is_out_of_board?(next_move)
    moves << next_move and return moves if has_oponent(piece, next_move)

    moves << next_move
    next_move = move_vertically(next_move, -1)
    generate_up_vertical_moves(piece, next_move, moves)
  end

  def generate_down_vertical_moves(piece, next_move = move_vertically(piece.position, 1), moves = [])
    return moves if has_ally(piece, next_move) || is_out_of_board?(next_move)
    moves << next_move and return moves if has_oponent(piece, next_move) || is_out_of_board?(next_move)

    moves << next_move
    next_move = move_vertically(next_move, 1)
    generate_down_vertical_moves(piece, next_move, moves)
  end

  def generate_left_horizontal_moves(piece, next_move = move_horizontally(piece.position, -1), moves = [])
    return moves if has_ally(piece, next_move)
    moves << next_move and return moves if has_oponent(piece, next_move) || is_out_of_board?(next_move)

    moves << next_move
    next_move = move_horizontally(next_move, -1)
    generate_left_horizontal_moves(piece, next_move, moves)
  end

  def snack_piece_at(position)
    piece = select_piece_at(position)
    @pieces.delete(piece)
  end

  def move_piece(piece, position)
    snack_piece_at(position) if has_oponent(piece, position)
    piece.position = position
  end

  def get_potential_moves(piece)
    moves = []
    moves << piece.potential_moves
    remove_invalid_moves(piece, moves)
    moves << special_case_pawn_moves(piece) if piece.is_a?(ChessPawn)
    moves.flatten(1)
  end

  def remove_invalid_moves(piece, moves)
    moves.delete_if { |pos| has_ally(piece, pos) }
  end

  def special_case_pawn_moves(pawn)
    direction = pawn.color == 'white' ? 1 : -1
    main_diag_move = move_main_diagonal(pawn.position, direction)
    sec_diag_move = move_secondary_diagonal(pawn.position, direction)

    valid_moves = []
    valid_moves << main_diag_move if has_oponent(pawn, main_diag_move)
    valid_moves << sec_diag_move if has_oponent(pawn, sec_diag_move)

    valid_moves
  end
end

