require_relative 'chess_game_move_module.rb'
require_relative '../chess_pieces/chess_rook.rb'
require_relative '../chess_pieces/chess_pawn.rb'
require_relative '../chess_pieces/chess_knight.rb'
require_relative 'move_generator.rb'

class ChessGame

  include MovePiece

  def initialize(board, player_1, player_2)
    @board = board
    @player_1 = player_1
    @player_2 = player_2
  end

  def play
    players = [@player_1, @player_2]
    until game_over?
      @board.update_board
      current_player = players.shift
      display_check_message(current_player) if is_player_check?(current_player)
      play_move(current_player)
      while is_player_check?(current_player)
        out_of_check_loop(current_player)
      end
      players << current_player
    end
  end

  def game_over?
  end

  def out_of_check_loop(current_player)
    @board.undo_last_move
    puts "#{current_player} You have to keep your king out of check!"
    play_move(current_player)
  end

  def is_player_check?(player)
    player_king = select_player_king(player)
    @board.is_check?(player_king)
  end

  def select_player_king(player)
    king = @board.pieces.find { |piece| piece.is_a?(ChessKing) && piece.color == player.color }
  end

  def play_move(player)
    start_position = select_piece_input(player)
    piece = @board.select_piece_at(start_position)
    to_position = move_piece_input(piece)
    @board.move_piece(piece, to_position)
    @board.clean_cell(start_position)
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
    possible_moves.include?(position)
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
    puts <<~HEREDOC
      Hey #{player.name} you are playing with #{player.color} pieces,
      select the piece you would like to move by typing it\'s position
    HEREDOC
  end

  def move_piece_message
    puts 'Type the square you want to move the piece to'
  end

  def display_check_message(player)
    puts "#{player.name} you are in check!"
  end
end
