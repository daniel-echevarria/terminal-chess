
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

  def valid_pick?(player, input)
    position = translate_chess_to_array(input)
    piece = select_piece(position)
    piece.color == player.color
  end

  def select_piece(position)
    # piece = @pieces.select { |piece| piece.position == position}
  end

  def select_piece_message
  end

  def translate_chess_to_array(input)
  end

  def create_pieces
  end
end
