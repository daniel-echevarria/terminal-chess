require_relative 'move_module.rb'
require_relative 'display.rb'
require_relative 'move_generator.rb'
require_relative 'chess_array_translator.rb'

require 'yaml'


class ChessGame
  include MovePiece
  include ChessArrayTranslator

  attr_accessor :current_player

  def initialize(board, player_one, player_two)
    @board = board
    @player_one = player_one
    @player_two = player_two
    @current_player = @player_one
    @mover = MoveGenerator.new(@board)
    @display = ChessDisplay.new
    @game_over = false
  end

  def save_game
    data = {
      board: @board,
      player_one: @player_one,
      player_two: @player_two,
      game_over: @game_over,
      current_player: @current_player
    }
    File.open('games.yaml', 'w') do |file|
      file.puts YAML.dump(data)
    end
    @display.confirm_saving_message
  end

  def self.load_game(path)
    data = YAML.unsafe_load(File.read(path))
    fresh_game = ChessGame.new(data[:board], data[:player_one], data[:player_two])
    fresh_game.current_player = data[:current_player]
    fresh_game
  end

  def play
    @board.update_board
    until @game_over
      assess_situation(@current_player)
      play_turn(@current_player) unless @game_over
      change_current_player
    end
  end

  def change_current_player
    @current_player = @current_player == @player_one ? @player_two : @player_one
  end

  def assess_situation(player)
    return handle_end_game(player) if player_cant_move?(player)

    @display.check_message(player) if player_check?(player)
  end

  def play_turn(player)
    play_move(player)
    out_of_check_loop(player) while player_check?(player)
    promoted_pawn = @board.select_promoted_pawn_of_color(player.color)
    handle_promotion(promoted_pawn, player) if promoted_pawn
    @board.update_board
  end

  def handle_end_game(player)
    @game_over = true
    player_check?(player) ? @display.check_mate_message(player) : @display.draw_message(player)
  end

  def player_check?(player)
    player_king = @board.select_king_of_color(player.color)
    @board.check?(player_king)
  end

  def play_move(player)
    loop do
      piece = select_movable_piece(player)
      target_position = moving_piece_loop(piece)
      next if target_position == 'exit'

      @display.confirm_move_message(piece, target_position)
      @board.update_board_without_moves
      return handle_castling(piece, target_position) || @board.move_piece(piece, target_position)
    end
  end

  def select_movable_piece(player)
    loop do
      start_position = piece_selection_loop(player)
      piece = @board.select_piece_at(start_position)
      return piece if piece_can_move?(piece)

      @display.piece_cant_move_message(piece)
    end
  end

  def piece_can_move?(piece)
    @display.confirm_selection_message(piece)
    possible_moves = @mover.generate_possible_moves_for_piece(piece)
    @board.display_moves(possible_moves)
    @board.update_board
    @display.possible_moves_message(piece, possible_moves)
    !possible_moves.empty?
  end

  def out_of_check_loop(current_player)
    @board.undo_last_move
    @display.keep_out_of_check_message(current_player)
    play_move(current_player)
  end

  def handle_promotion(pawn, player)
    @board.update_board
    piece_type = promotion_input_loop(player)
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

  def piece_selection_loop(player)
    @display.select_piece_message(player)
    loop do
      input = gets.chomp
      (save_game; next) if input == 'save'
      return translate_chess_to_array(input) if valid_pick?(player, input)

      @display.wrong_piece_selection_message(player)
    end
  end

  def valid_pick?(player, input)
    position = translate_chess_to_array(input)
    piece = @board.select_piece_at(position)
    return if piece.nil?

    piece.color == player.color
  end

  def moving_piece_loop(piece)
    @display.move_piece_message(piece)
    loop do
      input = gets.chomp
      (save_game; next) if input == 'save'
      return input if input == 'exit'
      return translate_chess_to_array(input) if valid_move?(input, piece)

      @display.wrong_move_message(input, piece)
    end
  end

  def valid_move?(input, piece)
    position = translate_chess_to_array(input)
    possible_moves = @mover.generate_possible_moves_for_piece(piece)
    possible_moves << @mover.generate_castling_moves(piece) if piece.specie == :king
    possible_moves.include?(position)
  end

  def promotion_input_loop(player)
    @display.promotion_message(player)
    loop do
      input = gets.chomp
      return input.to_sym if valid_promotion?(input)

      @display.wrong_promotion
    end
  end

  def valid_promotion?(input)
    valid_promotions = %w[queen bishop knight rook]
    valid_promotions.include?(input)
  end
end
