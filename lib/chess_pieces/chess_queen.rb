
class ChessQueen < ChessPiece

  def set_unicode
    @unicode = @color == 'white' ? "\u265B" : "\u2655"
  end
end
