
class ChessGame

  def initialize(board, player_1, player_2)
    @board = board
    @player_1 = player_1
    @player_2 = player_2
    @pieces = create_pieces
  end

  def play_move(player)
    from_chess_position = select_piece_input(player)
    from_array_position = translate_chess_to_array(from_chess_position)
    piece = select_piece(from_array_position)
    to_position = move_piece_input(piece)
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
    return if piece.nil?

    piece.color == player.color
  end

  def valid_move?(piece, chess_position)
    array_position = translate_chess_to_array(chess_position)
    possible_moves = get_potential_moves(piece)
    possible_moves.include?(array_position)
  end

  def get_potential_moves(piece)
    # given a piece and the board situation, output a list of all the possible moves the piece can make
    p piece.potential_moves
  end

  def select_piece(position)
    pieces = @pieces.flatten(1)
    piece = pieces.select { |piece| piece.position == position }
    piece[0]
  end

  def select_piece_message
    puts 'Select the piece you would like to move by typing it\'s position '
  end

  def move_piece_message
    puts 'Type the square you want to move the piece to'
  end

  def translate_chess_to_array(input)
    chess_rows = (8).downto(1).to_a
    chess_columns = ('a').upto('h').to_a
    col, row = input.split('')
    a_col = chess_columns.index(col)
    a_row = chess_rows.index(row.to_i)
    [a_row, a_col]
  end

  def create_pawns
    pawns = []
    (0..7).each_with_index do |num, index|
      pawns << ChessPawn.new([1, index], 'black')
      pawns << ChessPawn.new([6, index], 'white')
    end
    pawns
  end

  def create_pieces
    pieces = []
    pieces << create_pawns
    pieces
  end

  def inital_board_setup
    @board.populate_board(@pieces.flatten)
    @board.display_board
  end
end

