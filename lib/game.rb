require_relative 'move_module.rb'
require_relative 'display.rb'
require_relative 'move_generator.rb'
require_relative 'chess_array_translator.rb'

class ChessGame
  include MovePiece
  include ChessArrayTranslator

  def initialize(board, player_one, player_two)
    @board = board
    @player_one = player_one
    @player_two = player_two
    @mover = MoveGenerator.new(@board)
    @display = ChessDisplay.new
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

    @display.check_message(player) if player_check?(player)
  end

  def handle_end_game(player)
    @game_over = true
    player_check?(player) ? @display.check_mate_message(player) : @display.draw_message(player)
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
    @display.select_piece_message(player)
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
    @display.move_piece_message(piece)
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
    @display.promotion_message(player)
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
end
