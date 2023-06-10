require_relative '../chess_game/chess_game_move_module.rb'
require_relative '../chess_pieces/chess_piece.rb'

class ChessPawn < ChessPiece
  include MovePiece

  # def generate_possible_moves(board)
  #   # given all the pieces in the board and the position of the pawn
  #   # return all the possible moves of the pawn
  #   # declare a possible moves array
  #   # add the position in front of him unless there is an ally or an opponent
  #   # add the second position in fron of him if the pawn is on its initial position
  #   # add the position on the main diagonal if there is an opponent on it
  #   # add the position on the sec diagonal if there is an opponent on it
  #   possible_moves = []
  #   vertical_direction = @color == 'white' ? 1 : -1

  #   main_diag = move_main_diagonal(@position, 1 * vertical_direction)
  #   sec_diag = move_secondary_diagonal(@position, 1 * vertical_direction)
  #   one_in_front = move_vertically(@position, 1 * vertical_direction)
  #   two_in_front = move_vertically(@position, 2 * vertical_direction)

  #   possible_moves << main_diag if board.has_oponent(main_diag, self)
  #   possible_moves << sec_diag if board.has_oponent(sec_diag, self)

  #   return possible_moves if board.has_ally(one_in_front, self) || board.has_oponent(one_in_front, self)

  #   possible_moves << one_in_front
  #   possible_moves << two_in_front if on_initial_position? unless board.has_ally(two_in_front, self) || board.has_oponent(two_in_front, self)

  #   possible_moves
  # end

  def potential_moves
    moves = []
    vertical_direction = @color == 'white' ? -1 : 1
    moves << move_vertically(@position, 2 * vertical_direction) if on_initial_position?
    moves << move_vertically(@position, 1 * vertical_direction)
    moves
  end

  def on_initial_position?
    current_row = @position[0]
    initial_row = @color == 'white' ? 6 : 1

    current_row == initial_row
  end

  def set_unicode
    @unicode = @color == 'white' ? "\u265F" : "\u2659"
  end
end
