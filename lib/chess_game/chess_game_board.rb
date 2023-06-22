require_relative '../chess_pieces/pieces_creator.rb'
require_relative '../chess_game/move_generator.rb'

class ChessBoard
  # A Hash containing the info for setting up the major pieces as the game starts
  # the unicodes array follow the convention black unicode first (but it appears white on my terminal somehow)
  attr_reader :board, :pieces

  def initialize
    @board = create_board
    @pieces_creator = ChessPiecesCreator.new
    @pieces = @pieces_creator.pieces
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
      next if piece.position.any?(&:negative?)

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

  def select_piece_at(position)
    @pieces.find { |piece| piece.position == position }
  end

  def select_pieces_of_color(color)
    @pieces.select { |piece| piece.color == color }
  end

  def select_promoted_pawn_of_color(color)
    pieces = select_pieces_of_color(color)
    pawns = pieces.select { |p| p.specie == :pawn }
    pawns.find { |p| pawn_on_promotion_position?(p) }
  end

  def select_king_of_color(color)
    pieces = select_pieces_of_color(color)
    king = pieces.find { |piece| piece.specie == :king }
  end

  def move_piece(piece, future_position)
    snacked_piece = snack_piece_at(future_position) if position_has_oponent?(future_position, piece)
    snack_record = create_snack_record(snacked_piece, future_position) if snacked_piece

    move_record = create_move_record(piece, piece.position, future_position, snack_record)
    @move_history << move_record
    piece.position = future_position
  end

  def create_move_record(piece, previous, current, snack_record)
    move_hash = { piece: piece, from: previous, to: current, snack: snack_record }
  end

  def create_snack_record(piece, previous)
    snack_hash = { piece: piece, from: previous}
  end

  def undo_last_move
    last_move = @move_history.pop

    if last_move[:snack]
      snacked_piece = last_move[:snack][:piece]
      snacked_piece.position = last_move[:snack][:from]
    end

    piece = last_move[:piece]
    piece.position = last_move[:from]
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

  def position_has_oponent?(position, piece)
    opponent = select_piece_at(position)
    return false if opponent.nil?

    piece.color != opponent.color
  end

  def position_has_ally?(position, piece)
    ally = select_piece_at(position)
    return false if ally.nil?

    piece.color == ally.color
  end

  def position_is_out_of_board?(position)
    row, col = position
    row.between?(0, 7) && col.between?(0, 7) ? false : true
  end

  def select_opponent_pieces(piece)
    opponent_pieces = @pieces.select { |p| p.color != piece.color }
  end

  def get_opponent_possible_moves(king, mover)
    opponent_possible_moves = []
    opponent_pieces = select_opponent_pieces(king)
    opponent_pieces.each do |piece|
      opponent_possible_moves << mover.generate_possible_moves_for_piece(piece)
    end
    opponent_possible_moves.flatten(1)
  end

  def is_check?(king)
    opp_possibles_moves = get_opponent_possible_moves(king, MoveGenerator.new(self))
    opp_possibles_moves.include?(king.position)
  end

  def transform_pawn(pawn, major)
    upgrade = @pieces_creator.create_piece_at_position(major, pawn.position, pawn.color)
    pawn.position = [-1, -1]
    @pieces << upgrade
  end

  def valid_pick?(color, input)
    position = translate_chess_to_array(input)
    piece = @board.select_piece_at(position)
    return if piece.nil?

    piece.color == color
  end

  def pawn_on_initial_position?(pawn)
    current_row = pawn.position[0]
    initial_row = pawn.color == :white ? 6 : 1

    current_row == initial_row
  end

  def pawn_on_promotion_position?(pawn)
    current_row = pawn.position[0]
    promotion_row = pawn.color == :white ? 0 : 7

    current_row == promotion_row
  end
end

