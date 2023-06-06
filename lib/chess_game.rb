require_relative '../lib/chess_game_move_module.rb'

class ChessGame

  include MovePiece
  attr_reader :pieces

  def initialize(board, player_1, player_2)
    @board = board
    @player_1 = player_1
    @player_2 = player_2
  end

  def play_move(player)
    from_chess_position = select_piece_input(player)
    from_array_position = translate_chess_to_array(from_chess_position)
    piece = select_piece_at(from_array_position)
    to_chess_position = move_piece_input(piece)
    to_array_position = translate_chess_to_array(to_chess_position)
    move_piece(piece, to_array_position)
    @board.clean_cell(from_array_position)
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

  def select_piece_at(position)
    piece = @board.pieces.select { |piece| piece.position == position }
    piece.first
  end

  def select_piece_input(player)
    select_piece_message(player)
    input = gets.chomp
    until valid_pick?(player, input) do
      puts "Please input the position of a #{player.color} piece"
      input = gets.chomp
    end
    input
  end

  def move_piece_input(piece)
    move_piece_message
    chess_position = gets.chomp
    until valid_move?(piece, chess_position) do
      puts 'please input a valid move'
      chess_position = gets.chomp
    end
    chess_position
  end

  def valid_pick?(player, chess_position)
    array_position = translate_chess_to_array(chess_position)
    piece = select_piece_at(array_position)
    return if piece.nil?

    piece.color == player.color
  end

  def valid_move?(piece, chess_position)
    array_position = translate_chess_to_array(chess_position)
    possible_moves = get_potential_moves(piece)
    possible_moves.include?(array_position)
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

