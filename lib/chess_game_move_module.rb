
module MovePiece
  def move_vertically(position, num)
    position[0] += num
    position
  end

  def move_horizontally(position, num)
    position[1] += num
    position
  end

  def move_main_diagonal(position, num)
    position.map! { |v| v += num}
  end

  def move_secondary_diagonal(position, num)
    position[0] += num
    position[1] -= num
    position
  end

end
