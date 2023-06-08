
class ChessBishop < ChessPiece

  def set_unicode
    @unicode = @color == 'white' ? "\u265D" : "\u2657"
  end
end
