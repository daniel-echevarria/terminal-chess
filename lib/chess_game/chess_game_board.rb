require_relative '../chess_pieces/pieces_creator.rb'
require_relative '../chess_game/move_generator.rb'

class ChessBoard
  # A Hash containing the info for setting up the major pieces as the game starts
  # the unicodes array follow the convention black unicode first (but it appears white on my terminal somehow)
  attr_reader :board, :pieces

  def initialize
    @board = create_board
    @pieces = get_pieces
    @move_history = []
  end

  def create_board
    Array.new(8) { Array.new(8, " ") }
  end

  def reset_board
    @board = create_board
    @pieces = get_pieces
    @move_history = []
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

  # Pieces Related Methods

  def get_pieces
    piece_creator = ChessPiecesCreator.new
    piece_creator.pieces
  end

  def select_piece_at(position)
    @pieces.find { |piece| piece.position == position }
  end

  #  given a move, check if there is an opponent on the future position
  #  if there is, record that piece, with the original position in a snack symbole
  def move_piece(piece, future_position)
    if has_oponent?(piece, future_position)
      snacked = { piece: snack_piece_at(future_position), from: future_position}
    end

    original_postion = piece.position
    piece.position = future_position
    @move_history << { piece: piece, from: original_postion, to: future_position, snack: snacked }
    p @move_history
  end

  def snack_piece_at(position)
    piece = select_piece_at(position)
    piece.position = [-1, -1]
    piece
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
end

