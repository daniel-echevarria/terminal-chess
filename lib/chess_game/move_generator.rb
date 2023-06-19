require_relative '../../lib/chess_game/chess_game_move_module.rb'

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
    piece_type = piece.class.name
    case piece_type
    when 'ChessPawn'
      moves << generate_pawn_moves(piece)
    when 'ChessRook'
      moves << generate_rook_moves(piece)
    when 'ChessKnight'
      moves << generate_knight_moves(piece)
    when 'ChessBishop'
      moves << generate_bishop_moves(piece)
    when 'ChessQueen'
      moves << generate_queen_moves(piece)
    when 'ChessKing'
      moves << generate_king_moves(piece)
    end
    moves.flatten(1)
  end

  def get_possible_moves_for_color(color)
    pieces_possibles = []
    pieces = @board.pieces.select { |p| p.color == color }
    pieces.each do |piece|
      moves = generate_possible_moves_for_piece(piece)
      pieces_possibles << { piece: piece, possibles: moves }
    end
    pieces_possibles
  end

  def generate_pawn_moves(pawn)
    possible_moves = []
    direction = pawn.color == :white ? 1 : -1
    position = pawn.position

    main_diag = move_main_diagonal(position, direction)
    sec_diag = move_secondary_diagonal(position, direction)
    one_front = move_vertically(position, direction)
    two_front = move_vertically(position, 2 * direction)

    possible_moves << main_diag if @board.position_has_oponent?(pawn, main_diag)
    possible_moves << sec_diag if @board.position_has_oponent?(pawn, sec_diag)
    possible_moves << one_front if @board.position_is_free?(one_front)
    possible_moves << two_front if pawn.on_initial_position? && @board.position_is_free?(two_front) && @board.position_is_free?(one_front)

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
    moves = []

    possible_directions = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [2, -1], [2, 1], [1, -2], [1, 2]]

    potential_moves = possible_directions.map do |dir|
      row, col = knight.position.dup
      row += dir[0]
      col += dir[1]
      [row, col]
    end

    possible_moves = potential_moves.select { |move| !invalid_move_for_piece?(move, knight) }
    possible_moves
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

    possible_moves = potential_moves.select { |move| !invalid_move_for_piece?(move, king) }
    possible_moves
  end


  def generate_moves(piece, direction, next_move = move_one(piece.position, direction), moves = [])
    return moves if invalid_move_for_piece?(next_move, piece)
    moves << next_move
    return moves if @board.position_has_oponent?(next_move, piece)

    next_move = move_one(next_move, direction)
    generate_moves(piece, direction, next_move, moves)
  end
end
