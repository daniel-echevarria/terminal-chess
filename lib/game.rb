require_relative 'move_module.rb'
require_relative 'move_generator.rb'

class ChessGame
  include MovePiece

  def initialize(board, player_one, player_two)
    @board = board
    @player_one = player_one
    @player_two = player_two
    @mover = MoveGenerator.new(@board)
    @game_over = false
  end

  def play
    players = [@player_one, @player_two]
    display_board
    until @game_over
      current_player = players.shift
      assess_situation(current_player)
      play_turn(current_player) unless @game_over
      players << current_player
    end
  end

  def display_board
    @board.update_board
  end

  def assess_situation(player)
    return handle_end_game(player) if player_cant_move?(player)

    display_check_message(player) if player_check?(player)
  end

  def handle_end_game(player)
    @game_over = true
    player_check?(player) ? display_check_mate_message(player) : display_draw_message(player)
  end

  def play_turn(player)
    play_move(player)
    out_of_check_loop(player) while player_check?(player)
    promoted_pawn = @board.select_promoted_pawn_of_color(player.color)
    handle_promotion(promoted_pawn, player) if promoted_pawn
    display_board
  end

  def player_check?(player)
    player_king = @board.select_king_of_color(player.color)
    @board.check?(player_king)
  end

  def play_move(player)
    piece = piece_selection_loop(player)
    target_position = move_piece_input(piece)
    handle_castling(piece, target_position) || @board.move_piece(piece, target_position)
  end

  def piece_selection_loop(player)
    loop do
      start_position = select_piece_input(player)
      piece = @board.select_piece_at(start_position)
      return piece if piece_can_move?(piece)

      puts "This piece can't move!"
    end
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
    @board.transform_pawn(pawn, piece_type)
  end

  def handle_castling(piece, target_position)
    return unless castling?(piece, target_position)

    @board.castle(piece, target_position)
  end

  def castling?(piece, target_position)
    return false unless piece.specie == :king

    step_size_bigger_than_one?(piece.position[1], target_position[1])
  end

  def step_size_bigger_than_one?(start, target)
    step_size = start - target
    step_size.abs > 1
  end

  def player_cant_move?(player)
    moves_by_piece = @mover.get_possible_moves_for_color_by_piece(player.color)
    out_of_check_moves = select_check_free_moves(moves_by_piece, player)
    out_of_check_moves.empty?
  end

  def select_check_free_moves(moves_by_piece, player)
    check_free_moves = []
    moves_by_piece.each do |piece_and_moves|
      piece = piece_and_moves[:piece]
      possible_moves = piece_and_moves[:possibles]
      possible_moves.each do |move|
        @board.move_piece(piece, move)
        check_free_moves << [piece, move] unless player_check?(player)
        @board.undo_last_move
      end
    end
    check_free_moves
  end

  def select_piece_input(player)
    select_piece_message(player)
    input = gets.chomp
    until valid_pick?(player, input)
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
    move_piece_message(piece)
    input = gets.chomp
    until valid_move?(input, piece)
      puts 'please input a valid move or type "exit" to select another piece'
      input = gets.chomp
      return if input == 'exit'
    end
    translate_chess_to_array(input)
  end

  def valid_move?(input, piece)
    position = translate_chess_to_array(input)
    possible_moves = @mover.generate_possible_moves_for_piece(piece)
    possible_moves << @mover.generate_castling_moves(piece) if piece.specie == :king
    translated_moves = possible_moves.map { |move| translate_array_to_chess(move) }
    puts "These are the possible moves for #{piece.specie} #{translated_moves}"
    possible_moves.include?(position)
  end

  def promotion_input(player)
    display_promotion_message(player)
    input = gets.chomp
    until valid_promotion?(input)
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
    chess_rows = 8.downto(1).to_a
    chess_columns = 'a'.upto('h').to_a
    col, row = input.split('')
    a_col = chess_columns.index(col)
    a_row = chess_rows.index(row.to_i)
    [a_row, a_col]
  end

  def translate_array_to_chess(position)
    chess_rows = 8.downto(1).to_a
    chess_columns = 'a'.upto('h').to_a
    row, col = position
    c_row = chess_rows[row]
    c_col = chess_columns[col]
    [c_col, c_row].join
  end

  def select_piece_message(player)
    puts <<~HEREDOC
      \e[33m#{player.name} select the piece you would like to move by typing it\'s position\e[0m
    HEREDOC
  end

  def move_piece_message(piece)
    translated_piece_position = translate_array_to_chess(piece.position)
    puts
    puts "\e[32mYou just selected the #{piece.specie} on #{translated_piece_position}\e[0m"
    puts "\e[33mType the square you want to move the #{piece.specie} to\e[0m"
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
