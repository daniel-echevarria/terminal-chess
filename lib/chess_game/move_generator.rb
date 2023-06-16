require_relative '../../lib/chess_game/chess_game_move_module.rb'

class MoveGenerator
  include MovePiece

  attr_accessor :pieces

  def initialize(piece, board)
    @piece = piece
    @board = board
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
    when 'ChessKnight'
      moves << generate_knight_moves
    when 'ChessBishop'
      moves << generate_bishop_moves
    when 'ChessQueen'
      moves << generate_queen_moves
    when 'ChessKing'
      moves << generate_king_moves
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

    possible_directions = [:up, :down, :left, :right]
    possible_directions.each { |direction| moves << generate_moves(direction) }

    moves.flatten(1)
  end

  def generate_bishop_moves
    moves = []

    possible_directions = [:main_diag_up, :main_diag_down, :sec_diag_up, :sec_diag_down]
    possible_directions.each { |direction| moves << generate_moves(direction) }

    moves.flatten(1)
  end

  def generate_knight_moves
    moves = []

    possible_directions = [[-2, -1], [-2, 1], [-1, -2], [-1, 2], [2, -1], [2, 1], [1, -2], [1, 2]]

    potential_moves = possible_directions.map do |dir|
      row, col = @piece.position.dup
      row += dir[0]
      col += dir[1]
      [row, col]
    end

    possible_moves = potential_moves.select { |move| !invalid_move?(move) }
    possible_moves
  end

  def generate_queen_moves
    moves = []

    moves << generate_bishop_moves
    moves << generate_rook_moves

    moves.flatten(1)
  end

  def generate_king_moves
    moves = []

    possible_directions = [:up, :down, :left, :right, :main_diag_up, :main_diag_down, :sec_diag_up, :sec_diag_down]
    potential_moves = possible_directions.map do |dir|
      row, col = @piece.position.dup
      row += DIRECTIONS[dir][0]
      col += DIRECTIONS[dir][1]
      [row, col]
    end

    possible_moves = potential_moves.select { |move| !invalid_move?(move) }
    possible_moves
  end


  def generate_moves(direction, next_move = move_one(@piece.position, direction), moves = [])
    return moves if invalid_move?(next_move)
    moves << next_move
    return moves if @board.has_oponent?(@piece, next_move)

    next_move = move_one(next_move, direction)
    generate_moves(direction, next_move, moves)
  end
end
