require_relative '../chess_game/chess_game_move_module.rb'
require_relative '../chess_pieces/chess_piece.rb'

class ChessRook < ChessPiece
  include MovePiece

  def set_unicode
    @unicode = @color == 'white' ? "\u265C" : "\u2656"
  end

end
