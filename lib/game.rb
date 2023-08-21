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
    @resigned = nil
  end

  def play
    @board.update_board_without_moves
    until @game_over
      assess_situation(@current_player)
      play_turn(@current_player) unless @game_over
      change_current_player(@current_player)
    end
  end

  def assess_situation(player)
    return handle_end_game(player) if player_cant_move?(player)

    @display.check_message(player) if player_check?(player)
  end

  # Algo for game_is_draw?
  # Check if there are less than four alive pieces
  # If there are and there is no queen or pawn or tour the game is draw
  # otherwise do nothing

  def can_somebody_win?
    return false if @board.count_pieces < 5 && @board.pieces.none?(&:winable_piece?)
  end

  def play_turn(player)
    play_move_loop(player)
    promoted_pawn = @board.select_promoted_pawn_of_color(player.color)
    handle_promotion(promoted_pawn, player) if promoted_pawn
  end

  def change_current_player(player)
    @current_player = select_other_player(player)
  end

  def select_other_player(player)
    player == @player_one ? @player_two : @player_one
  end

  def handle_end_game(player)
    @game_over = true
    winner = select_other_player(player)
    player_check?(player) ? @display.check_mate_message(player, winner) : @display.draw_message(player)
  end

  def player_check?(player)
    player_king = @board.select_king_of_color(player.color)
    @board.check?(player_king)
  end

  def player_resigned(player)
    @resigned = player
    winner = select_other_player(player)
    @display.resign_message(player, winner)
    @game_over = true
  end

  def play_move_loop(player)
    loop do
      @display.select_piece_message(player)
      piece = piece_selection_loop(player)
      return player_resigned(player) if piece.nil?

      possible_moves = get_possible_moves_for_piece(piece, player)
      (@display.piece_cant_move_message(piece); next) if possible_moves.empty?

      @board.update_board_with_moves(possible_moves)
      @display.confirm_selection_message(player, piece)

      @display.move_piece_message(piece)
      target_position = moving_piece_loop(piece, possible_moves)
      return player_resigned(player) if target_position.nil?

      (@board.update_board_without_moves; next) if target_position == 'exit'

      castling?(piece, target_position) ? @board.castle(piece, target_position) : @board.move_piece(piece, target_position)
      @board.update_board_without_moves
      @display.confirm_move_message(player, piece, target_position)
      return
    end
  end

  def get_possible_moves_for_piece(piece, player)
    moves = @mover.generate_possible_moves_for_piece(piece)
    moves << @mover.generate_castling_moves(piece) if piece.specie == :king
    select_check_free_moves_for_piece(piece, moves, player)
  end

  def handle_promotion(pawn, player)
    piece_type = promotion_input_loop(player)
    @board.transform_pawn(pawn, piece_type)
    @board.update_board_without_moves
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
    moves_by_piece = @mover.get_possibles_moves_by_piece_for_color(player.color)
    check_free_moves = select_check_free_moves(moves_by_piece, player)
    out_of_check_moves = check_free_moves.reject(&:empty?)
    out_of_check_moves.empty?
  end

  def select_check_free_moves_for_piece(piece, moves, player)
    check_free_moves = []
    moves.each do |move|
      @board.move_piece(piece, move)
      check_free_moves << move unless player_check?(player)
      @board.undo_last_move
    end
    check_free_moves
  end

  def select_check_free_moves(moves_by_piece, player)
    check_free_moves = []
    moves_by_piece.each do |piece_and_moves|
      piece = piece_and_moves[:piece]
      moves = piece_and_moves[:possibles]
      check_free_moves << select_check_free_moves_for_piece(piece, moves, player)
    end
    check_free_moves
  end

  def piece_selection_loop(player)
    loop do
      input = gets.chomp
      return if input == 'resign'

      (save_game; next) if input == 'save'

      position = translate_chess_to_array(input)
      piece = @board.select_piece_at(position)
      return piece if valid_pick?(piece, player)

      @display.wrong_piece_selection_message(player)
    end
  end

  def valid_pick?(piece, player)
    return if piece.nil?

    piece.color == player.color
  end

  def moving_piece_loop(piece, possible_moves)
    loop do
      input = gets.chomp
      return input if input == 'exit'
      return if input == 'resign'

      (save_game; next) if input == 'save'

      target_position = translate_chess_to_array(input)
      return target_position if possible_moves.include?(target_position)

      @display.wrong_move_message(input, piece)
    end
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

  def save_game
    data = {
      board: @board,
      player_one: @player_one,
      player_two: @player_two,
      game_over: @game_over,
      current_player: @current_player
    }
    File.open('saved_game.yaml', 'w') do |file|
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
end
