

class ChessKing < ChessPiece

  def set_unicode
    @unicode = @color == 'white' ? "\u265A" : "\u2654"
  end
end
