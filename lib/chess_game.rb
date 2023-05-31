
class ChessGame

  def initialize(board, player_1, player_2)
    @board = board
    @player_1 = player_1
    @player_2 = player_2
    @pieces = create_pieces
  end

  def select_piece_input(player)
    select_piece_message
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
    piece = select_piece(array_position)
    piece.color == player.color
  end

  def valid_move?(piece, chess_position)
    possible_moves = get_possible_moves(piece, @board)
    possible_moves.include?(chess_position)
  end

  def get_possible_moves(piece, board)
    # given a piece and the board situation, output a list of all the possible moves the piece can make
  end

  def select_piece(position)
    # select the piece that matches the position
    # piece = @pieces.select { |piece| piece.position == position}
  end

  def select_piece_message
  end

  def move_piece_message
  end

  def translate_chess_to_array(input)
    chess_rows = (8).downto(1).to_a
    chess_columns = ('a').upto('h').to_a
    col, row = input.split('')
    a_col = chess_columns.index(col)
    a_row = chess_rows.index(row.to_i)
    [a_row, a_col]
  end

  def create_pieces
  end
end
