require_relative '../../lib/chess_game/chess_game_move_module.rb'

class MoveGenerator
  include MovePiece

  attr_accessor :pieces

  def initialize(piece, board)
    @piece = piece
    @board = board
  end

  def select_piece_at(position)
    @board.pieces.find { |piece| piece.position == position }
  end

  def invalid_move?(position)
    has_ally?(position) || is_out_of_board?(position)
  end

  def position_is_free?(position)
    positions = @board.pieces.map(&:position)
    !positions.include?(position)
  end

  def generate_possible_moves
    moves = []
    piece_type = @piece.class.name
    case piece_type
    when 'ChessPawn'
      moves << generate_pawn_moves
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

    possible_moves << main_diag if has_oponent(main_diag)
    possible_moves << sec_diag if has_oponent(sec_diag)
    possible_moves << one_front if position_is_free?(one_front)
    possible_moves << two_front if @piece.on_initial_position? && position_is_free?(two_front) && position_is_free?(one_front)

    possible_moves
  end

  def generate_rook_moves
    moves = []

    moves << generate_up_vertical_moves(@piece)
    moves << generate_down_vertical_moves(@piece)
    moves << generate_left_horizontal_moves(@piece)
    moves << generate_right_horizontal_moves(@piece)

    moves
  end

  def has_oponent(position)
    piece = select_piece_at(position)
    return false if piece.nil?

    piece.color != @piece.color
  end

  def has_ally?(position)
    piece = select_piece_at(position)
    return false if piece.nil?

    piece.color == @piece.color
  end

  def is_out_of_board?(position)
    row, col = position
    row.between?(0, 7) && col.between?(0, 7) ? false : true
  end

  def select_direction(direction_symbol)
    DIRECTIONS[direction_symbol]
  end

  # given a direction and a piece return all the possible moves on that direction
  # if next move is invalid return moves (enmpty)
  # if next move has an opponent add the next move to moves and return moves
  # otherwise call generate moves on the next square

  def generate_moves(piece, direction, next_move = move_one(piece.position, direction), moves = [])
    return moves if invalid_move?(next_move)
    moves << next_move
    return moves if has_oponent(next_move)

    next_move = move_one(next_move, direction)
    generate_moves(piece, direction, next_move, moves)
  end



  def generate_up_vertical_moves(piece, next_move = move_vertically(piece.position, 1), moves = [])
    return moves if invalid_move?(next_move)
    return moves if has_oponent(next_move)

    moves << next_move
    next_move = move_vertically(next_move, 1)
    generate_up_vertical_moves(piece, next_move, moves)
  end

  def generate_down_vertical_moves(piece, next_move = move_vertically(piece.position, -1), moves = [])
    return moves if invalid_move?(next_move)
    moves << next_move and return moves if has_oponent(piece, next_move)

    moves << next_move
    next_move = move_vertically(next_move, -1)
    generate_down_vertical_moves(piece, next_move, moves)
  end

  def generate_left_horizontal_moves(piece, next_move = move_horizontally(piece.position, -1), moves = [])
    return moves if invalid_move?(next_move)
    moves << next_move and return moves if has_oponent(piece, next_move)

    moves << next_move
    next_move = move_horizontally(next_move, -1)
    generate_left_horizontal_moves(piece, next_move, moves)
  end


  def generate_right_horizontal_moves(piece, next_move = move_horizontally(piece.position, -1), moves = [])
    return moves if invalid_move?(next_move)
    moves << next_move and return moves if has_oponent(piece, next_move)

    moves << next_move
    next_move = move_horizontally(next_move, 1)
    generate_righ_horizontal_moves(piece, next_move, moves)
  end

  def snack_piece_at(position)
    piece = select_piece_at(position)
    @pieces.delete(piece)
  end

  def move_piece(piece, position)
    snack_piece_at(position) if has_oponent(piece, position)
    piece.position = position
  end
end

  # def get_potential_moves(piece)
  #   moves = []
  #   moves << piece.potential_moves
  #   remove_invalid_moves(piece, moves)
  #   piece) if piece.is_a?(ChessPawn)
  #   moves.flatten(1)
  # end

  # def remove_invalid_moves(piece, moves)
  #   { |pos| has_ally(piece, pos) }
  # end

#   def special_case_pawn_moves(pawn)
#     direction = pawn.color == 'white' ? 1 : -1
#     main_diag_move = move_main_diagonal(pawn.position, direction)
#     sec_diag_move = move_secondary_diagonal(pawn.position, direction)

#     invalid_moves = []
#     if has_oponent(pawn, main_diag_move)
#     if has_oponent(pawn, sec_diag_move)
#  unless invalid_move(one_front)
