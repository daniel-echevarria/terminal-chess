require_relative '../lib/move_module.rb'

class MoveGenerator
  include MovePiece

  def initialize(board)
    @board = board
  end

  def invalid_move_for_piece?(position, piece)
    @board.position_has_ally?(position, piece) || @board.position_is_out_of_board?(position)
  end

  def generate_possible_moves_for_piece(piece)
    moves = []
    case piece.specie
    when :pawn
      moves << generate_pawn_moves(piece)
    when :rook
      moves << generate_rook_moves(piece)
    when :knight
      moves << generate_knight_moves(piece)
    when :bishop
      moves << generate_bishop_moves(piece)
    when :queen
      moves << generate_queen_moves(piece)
    when :king
      moves << generate_king_moves(piece)
    end
    moves.flatten(1)
  end

  def get_possible_moves_for_color(color)
    pieces_possibles = []
    pieces = @board.select_pieces_of_color(color)
    pieces.each do |piece|
      moves = generate_possible_moves_for_piece(piece)
      pieces_possibles << moves
    end
    pieces_possibles.flatten(1)
  end

  def get_possibles_moves_by_piece_for_color(color)
    pieces_possibles = []
    pieces = @board.select_pieces_of_color(color)
    alive_pieces = pieces.select { |piece| piece.position[0] >= 0 }
    alive_pieces.each do |piece|
      moves = generate_possible_moves_for_piece(piece)
      pieces_possibles << { piece: piece, possibles: moves }
    end
    pieces_possibles.flatten(1)
  end

  def generate_pawn_moves(pawn)
    possible_moves = []
    direction = pawn.color == :white ? 1 : -1
    position = pawn.position

    main_diag = move_main_diagonal(position, direction)
    sec_diag = move_secondary_diagonal(position, direction)
    one_front = move_vertically(position, direction)
    two_front = move_vertically(position, 2 * direction)

    possible_moves << main_diag if @board.position_has_oponent?(main_diag, pawn) || @board.en_passant_permitted?(pawn, main_diag)
    possible_moves << sec_diag if @board.position_has_oponent?(sec_diag, pawn) || @board.en_passant_permitted?(pawn, sec_diag)
    possible_moves << one_front if @board.position_is_free?(one_front)
    possible_moves << two_front if @board.pawn_on_initial_position?(pawn) && @board.position_is_free?(two_front) && @board.position_is_free?(one_front)

    possible_moves
  end

  def generate_rook_moves(rook)
    moves = []

    possible_directions = [:up, :down, :left, :right]
    possible_directions.each { |direction| moves << generate_moves(rook, direction) }

    moves.flatten(1)
  end

  def generate_bishop_moves(bishop)
    moves = []

    possible_directions = [:main_diag_up, :main_diag_down, :sec_diag_up, :sec_diag_down]
    possible_directions.each { |direction| moves << generate_moves(bishop, direction) }

    moves.flatten(1)
  end

  def generate_knight_moves(knight)
    possible_directions = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [2, -1], [2, 1], [1, -2], [1, 2]]

    potential_moves = possible_directions.map do |dir|
      row, col = knight.position.dup
      row += dir[0]
      col += dir[1]
      [row, col]
    end

    potential_moves.reject { |move| invalid_move_for_piece?(move, knight) }
  end

  def generate_queen_moves(queen)
    moves = []

    moves << generate_bishop_moves(queen)
    moves << generate_rook_moves(queen)

    moves.flatten(1)
  end

  def generate_king_moves(king)
    moves = []

    possible_directions = [:up, :down, :left, :right, :main_diag_up, :main_diag_down, :sec_diag_up, :sec_diag_down]
    potential_moves = possible_directions.map do |dir|
      row, col = king.position.dup
      row += DIRECTIONS[dir][0]
      col += DIRECTIONS[dir][1]
      [row, col]
    end
    moves << potential_moves.reject { |move| invalid_move_for_piece?(move, king) }
    moves.flatten(1)
  end

  def generate_castling_moves(king)
    potential_castling_moves = []
    same_color_rooks = @board.get_same_color_rooks(king)
    same_color_rooks.each do |rook|
      castling_trajectory = @board.get_castling_trajectory(king, rook)
      potential_castling_moves << castling_trajectory[1] if @board.castling_is_permitted?(king, rook)
    end
    potential_castling_moves.flatten(1)
  end

  def generate_moves(piece, direction)
    moves = []
    next_position = move_one(piece.position, direction)
    until invalid_move_for_piece?(next_position, piece)
      moves << next_position
      return moves if @board.position_has_oponent?(next_position, piece)

      next_position = move_one(next_position, direction)
    end
    moves
  end
end
