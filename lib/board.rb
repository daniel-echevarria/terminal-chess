require_relative 'pieces_creator.rb'
require_relative 'move_generator.rb'

require 'colorize'

class ChessBoard
  # A Hash containing the info for setting up the major pieces as the game starts
  # the unicodes array follow the convention black unicode first (but it appears white on my terminal somehow)
  attr_reader :board, :pieces, :move_history

  def initialize
    @board = create_board
    @mover = MoveGenerator.new(self)
    @pieces_creator = ChessPiecesCreator.new
    @pieces = @pieces_creator.pieces
    @move_history = []
  end

  def create_board
    board = Array.new(8) { Array.new(8, '   ') }
    colorize_board(board)
  end

  def define_background_color(num)
    num.odd? ? :cyan : :yellow
  end

  def colorize_board(board)
    board.each_with_index do |row, ind|
      row.each_with_index do |col, i|
        color = define_background_color(ind + i)
        board[ind][i] = '   '.colorize(background: color)
      end
    end
  end

  def create_pieces
    pieces_creator = ChessPiecesCreator.new
    pieces_creator.pieces
  end

  def reset_board
    @board = create_board
    @mover = MoveGenerator.new(self)
    @pieces_creator = ChessPiecesCreator.new
    @pieces = @pieces_creator.pieces
    @move_history = []
  end

  def populate_board(pieces)
    pieces.each do |piece|
      next if piece.position.any?(&:negative?)

      row, col = piece.position
      color = define_background_color(row + col)
      @board[row][col] = " #{piece.unicode} ".colorize(color: :black, background: color)
    end
  end

  def clean_cell(position)
    row, col = position
    color = define_background_color(row + col)
    @board[row][col] = '   '.colorize(background: color)
  end

  def display_board
    i = 8
    print "    #{('a'..'h').to_a.join('  ')}  "
    puts
    @board.each do |row|
      puts " #{i} #{row.join} #{i}"
      i -= 1
    end
    print "    #{('a'..'h').to_a.join('  ')}  "
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
    pawns = pieces.select { |piece| piece.specie == :pawn }
    pawns.find { |pawn| pawn_on_promotion_position?(pawn) }
  end

  def select_king_of_color(color)
    pieces = select_pieces_of_color(color)
    pieces.find { |piece| piece.specie == :king }
  end

  def move_piece(piece, future_position)
    original_position = piece.position.dup
    snacked_piece = handle_snack(future_position, piece)
    handle_move_recording(piece, future_position, snacked_piece)
    piece.position = future_position
    clean_cell(original_position)
  end

  def handle_move_recording(piece, future_position, snacked_piece)
    snack_record = create_snack_record(snacked_piece, future_position) if snacked_piece
    move_record = create_move_record(piece, piece.position, future_position, snack_record)
    @move_history << move_record
  end

  def handle_snack(future_position, piece)
    if position_has_oponent?(future_position, piece)
      snack_piece_at(future_position)
    elsif pawn_snacking_en_passant?(piece, future_position)
      snack_piece_en_passant_at(future_position, piece)
    end
  end

  # Algo for pawn_snacking_en_passant?
  # Given a piece and its future position
  # return unless the piece is a pawn
  # If the future position is not on the same column as the pawn and the future position has no opponent
  # the pawn is snacking en passant

  def pawn_snacking_en_passant?(pawn, future_position)
    return unless pawn.specie == :pawn && position_is_free?(future_position)

    pawn_changing_columns?(pawn, future_position)
  end

  def pawn_changing_columns?(pawn, future_position)
    pawn_col = pawn.position[1]
    future_col = future_position[1]
    pawn_col != future_col
  end

  def snack_piece_en_passant_at(future_position, piece)
    # p "snack piece en passant gets called by #{piece} for #{future_position}"
    direction = piece.color == :white ? 1 : -1
    futur_row, futur_col = future_position
    snack_row = futur_row + direction
    snack_position = [snack_row, futur_col]
    # p snack_position
    clean_cell(snack_position)
    snack_piece_at(snack_position)
  end

  def snack_piece_at(position)
    piece = select_piece_at(position)
    piece.position = [-1, -1]
    piece
  end

  def create_move_record(piece, previous, current, snack_record)
    { piece: piece, from: previous, to: current, snack: snack_record }
  end

  def create_snack_record(piece, previous)
    { piece: piece, from: previous }
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

  def position_is_free?(pos)
    positions = @pieces.map(&:position)
    !positions.include?(pos)
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

  def position_is_threatened?(position, opponent_color)
    opponent_possible_moves = @mover.get_possible_moves_for_color(opponent_color)
    opponent_possible_moves.include?(position)
  end

  def check?(king)
    opponent_color = king.color == :white ? :black : :white
    position_is_threatened?(king.position, opponent_color)
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

  def pawn_on_en_passant_position?(pawn)
    current_row = pawn.position[0]
    en_passant_row = pawn.color == :white ? 3 : 4

    current_row == en_passant_row
  end

  def select_potential_en_passant_snack(pawn, diagonal_move)
    direction = pawn.color == :white ? 1 : -1
    row, col = diagonal_move
    snack_row = row + direction
    snack = select_piece_at([snack_row, col])
    return snack if snack && snack.specie == :pawn
  end

  def select_last_moved_piece
    @move_history.last[:piece]
  end

  def en_passant_permitted?(pawn, diagonal_move)
    return unless pawn_on_en_passant_position?(pawn)

    potential_snack = select_potential_en_passant_snack(pawn, diagonal_move)
    return unless potential_snack == select_last_moved_piece
    return unless piece_moved_two_rows?(@move_history.last)

    true
  end

  def piece_moved_two_rows?(move_record)
    start_row = move_record[:from][0]
    target_row = move_record[:to][0]
    step_size = start_row - target_row
    step_size.abs == 2
  end

  def piece_moved?(piece)
    moved_pieces = @move_history.map { |hash| hash[:piece] }
    moved_pieces.any? { |p| p == piece }
  end

  def castling_is_permitted?(king, rook)
    castling_trajectory = get_castling_trajectory(king, rook)
    king_trajectory = castling_trajectory[0..1]
    opponent_color = king.color == :white ? :black : :white

    return false if piece_moved?(king) || piece_moved?(rook)
    return false unless castling_trajectory.all? { |pos| position_is_free?(pos) }
    return false if king_trajectory.any? { |pos| position_is_threatened?(pos, opponent_color) }

    true
  end

  def get_castling_trajectory(king, rook)
    king_row, king_col = king.position
    rook_col = rook.position[1]

    positions = []
    direction = king_col < rook_col ? +1 : -1

    until king_col == (rook_col - direction)
      king_col += direction
      positions << [king_row, king_col]
    end

    positions
  end

  def get_same_color_rooks(king)
    @pieces.select { |piece| piece.specie == :rook && piece.color == king.color }
  end

  def castle(king, target_position)
    rooks = get_same_color_rooks(king)
    castling_rook = select_closest_rook(rooks, target_position)
    rook_row, rook_col = castling_rook.position
    direction = king.position[1] > target_position[1] ? 1 : -1
    rook_target_position = [rook_row, target_position[1] + direction]
    move_piece(king, target_position)
    move_piece(castling_rook, rook_target_position)
  end

  def select_closest_rook(rooks, target_position)
    return rooks.first if rooks.length < 2

    first_rook = rooks[0]
    second_rook = rooks[1]

    distance_first_rook = first_rook.position[1] - target_position[1]
    disance_second_rook = second_rook.position[1] - target_position[1]

    distance_first_rook.abs < disance_second_rook.abs ? first_rook : second_rook
  end
end
