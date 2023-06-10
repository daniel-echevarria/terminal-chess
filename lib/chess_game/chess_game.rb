require_relative 'chess_game_move_module.rb'
require_relative '../chess_pieces/chess_rook.rb'
require_relative '../chess_pieces/chess_pawn.rb'
require_relative '../chess_pieces/chess_knight.rb'
require_relative 'move_generator.rb'

class ChessGame

  include MovePiece
  attr_reader :pieces

  def initialize(board, player_1, player_2)
    @board = board
    @player_1 = player_1
    @player_2 = player_2
  end

  def play_move(player)
    start_position = select_piece_input(player)
    piece = @board.select_piece_at(start_position)
    to_position = move_piece_input(piece)
    move_piece(piece, to_position)
    @board.clean_cell(start_position)
  end


  def play_round
    players = [@player_1, @player_2]
    until game_over?
      @board.update_board
      current_player = players.shift
      play_move(current_player)
      players << current_player
    end
  end

  def game_over?
  end

  def snack_piece_at(position)
    piece = @board.select_piece_at(position)
    @pieces.delete(piece)
  end

  # given a position and a piece list all the possible moves

  def move_piece(piece, position)
    snack_piece_at(position) if has_oponent(piece, position)
    piece.position = position
  end

  def select_piece_input(player)
    select_piece_message(player)
    input = gets.chomp
    until valid_pick?(player, input) do
      puts "Please input the position of a #{player.color} piece"
      input = gets.chomp
    end
    translate_chess_to_array(input)
  end

  def valid_pick?(player, input)
    position = translate_chess_to_array(input)
    piece = @board.select_piece_at(position)
    return if piece.nil?

    piece.color == player.color
  end

  def move_piece_input(piece)
    move_piece_message
    input = gets.chomp
    until valid_move?(piece, input) do
      puts 'please input a valid move'
      input = gets.chomp
    end
    translate_chess_to_array(input)
  end

  def valid_move?(piece, input)
    position = translate_chess_to_array(input)
    mover = MoveGenerator.new(piece, @board)
    possible_moves = mover.generate_possible_moves
    p possible_moves
    possible_moves.include?(position)

  end

  # Get info about a position

  def has_oponent(moving_piece, position)
    piece = @board.select_piece_at(position)
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
    moves << next_move and return moves if has_oponent(piece, next_move)

    moves << next_move
    next_move = move_vertically(next_move, 1)
    generate_down_vertical_moves(piece, next_move, moves)
  end

  def generate_left_horizontal_moves(piece, next_move = move_horizontally(piece.position, -1), moves = [])
    return moves if has_ally(piece, next_move) || is_out_of_board?(next_move)
    moves << next_move and return moves if has_oponent(piece, next_move)

    moves << next_move
    next_move = move_horizontally(next_move, -1)
    generate_left_horizontal_moves(piece, next_move, moves)
  end

  def generate_right_horizontal_moves(piece, next_move = move_horizontally(piece.position, 1), moves = [])
    return moves if has_ally(piece, next_move) || is_out_of_board?(next_move)
    moves << next_move and return moves if has_oponent(piece, next_move)

    moves << next_move
    next_move = move_horizontally(next_move, 1)
    generate_right_horizontal_moves(piece, next_move, moves)
  end

  def get_potential_moves(piece)
    moves = []
    if piece.is_a?(ChessPawn)
      moves << piece.potential_moves
      moves << special_case_pawn_moves(piece)
    end
    moves << generate_up_vertical_moves(piece)
    moves << generate_down_vertical_moves(piece)
    moves << generate_left_horizontal_moves(piece)
    moves << generate_right_horizontal_moves(piece)
    remove_invalid_moves(piece, moves)
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

  def translate_chess_to_array(input)
    chess_rows = (8).downto(1).to_a
    chess_columns = ('a').upto('h').to_a
    col, row = input.split('')
    a_col = chess_columns.index(col)
    a_row = chess_rows.index(row.to_i)
    [a_row, a_col]
  end

  def select_piece_message(player)
    puts "Hey #{player.name} you'r are playing with #{player.color} pieces,  select the piece you would like to move by typing it\'s position"
  end

  def move_piece_message
    puts 'Type the square you want to move the piece to'
  end
end
