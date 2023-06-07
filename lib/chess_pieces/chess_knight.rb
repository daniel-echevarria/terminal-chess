require_relative 'chess_piece.rb'

class ChessKnight < ChessPiece

  def set_unicode
    @unicode = @color == 'white' ? "\u265E" : "\u2658"
  end
end
