
module MovePiece
  def move_vertically(position, num)
    copy = position.dup
    copy[0] -= num
    copy
  end

  def move_horizontally(position, num)
    copy = position.dup
    copy[1] += num
    copy
  end

  def move_main_diagonal(position, num)
    copy = position.dup
    copy.map! { |v| v -= num}
  end

  def move_secondary_diagonal(position, num)
    copy = position.dup
    copy[0] -= num
    copy[1] += num
    copy
  end

end
