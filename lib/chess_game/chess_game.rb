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
    @mover = MoveGenerator.new(@board)
    @check_mate = nil
    @game_is_draw = false
  end

  def play
    players = [@player_1, @player_2]
    update_board
    until game_over?
      current_player = players.shift
      opponent = players.first
      play_turn(current_player)
      handle_lost_or_draw(opponent) if player_cant_move?(opponent)
      players << current_player
    end
  end

  def update_board
    @board.update_board
  end

  def game_over?
    @check_mate || @game_is_draw
  end

  def play_turn(player)
    display_check_message(player) if is_player_check?(player)
    play_move(player)
    while is_player_check?(player)
      out_of_check_loop(player)
    end
    promoted_pawn = @board.select_promoted_pawn_of_color(player.color)
    handle_promotion(promoted_pawn, player) if promoted_pawn
    update_board
  end

  def is_player_check?(player)
    player_king = @board.select_king_of_color(player.color)
    @board.is_check?(player_king)
  end

  def play_move(player)
    from_position = select_piece_input(player)
    piece = @board.select_piece_at(from_position)
    until piece_can_move?(piece)
      puts "This piece can't move!"
      from_position = select_piece_input(player)
      piece = @board.select_piece_at(from_position)
    end
    to_position = move_piece_input(piece)
    @board.move_piece(piece, to_position)
    @board.clean_cell(from_position)
  end

  def piece_can_move?(piece)
    possible_moves = @mover.generate_possible_moves_for_piece(piece)
    !possible_moves.empty?
  end

  def out_of_check_loop(current_player)
    @board.undo_last_move
    puts "#{current_player.name} You have to keep your king out of check!"
    play_move(current_player)
  end

  def handle_promotion(pawn, player)
    piece_type = promotion_input(player)
    @board.promote_pawn(pawn, piece_type)
  end

  def handle_lost_or_draw(player)
    is_player_check?(player) ? handle_chechmate(player) : game_is_draw
  end

  def game_is_draw
    @game_is_draw = true
    display_draw_message
  end

  def handle_chechmate(player)
    @check_mate = player
    display_check_mate_message(player)
  end

  def player_cant_move?(player)
    pieces_and_moves = @mover.get_possible_moves_for_color(player.color)
    out_of_check_moves = select_check_free_moves(pieces_and_moves, player)
    out_of_check_moves.empty?
  end

  def select_check_free_moves(pieces_and_moves, player)
    check_free = []
    pieces_and_moves.each do |p_and_moves|
      piece = p_and_moves[:piece]
      possibles = p_and_moves[:possibles]
      possibles.each do |move|
        @board.move_piece(piece, move)
        check_free << [piece, move] unless is_player_check?(player)
        @board.undo_last_move
      end
    end
    check_free
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
    until valid_move?(input, piece) do
      puts 'please input a valid move'
      input = gets.chomp
    end
    translate_chess_to_array(input)
  end

  def valid_move?(input, piece)
    position = translate_chess_to_array(input)
    possible_moves = @mover.generate_possible_moves_for_piece(piece)
    possible_moves.include?(position)
  end

  def promotion_input(player)
    display_promotion_message(player)
    input = gets.chomp
    until valid_promotion?(input) do
      display_wrong_promotion
      input = gets.chomp
    end
    input.to_sym
  end

  def valid_promotion?(input)
    valid_promotions = %w[queen bishop knight rook]
    valid_promotions.include?(input)
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
      #{player.name} select the piece you would like to move by typing it\'s position
    HEREDOC
  end

  def move_piece_message
    puts 'Type the square you want to move the piece to'
  end

  def display_check_message(player)
    puts "#{player.name} you are in check!"
  end

  def display_check_mate_message(player)
    puts "Game is over, #{player.name} you are check_mate!"
  end

  def display_promotion_message(player)
    puts "Hey #{player} which piece do you want to promote the pawn to ?"
  end

  def display_wrong_promotion
    puts <<~HEREDOC
      Please input a valid piece to promote the pawn to, the options are:
      queen
      bishop
      knight
      rook
    HEREDOC
  end

  def display_draw_message
    puts 'Congratulations girls the game is draw and you both won! (or none of you did depending how you want to look at it)'
  end
end
