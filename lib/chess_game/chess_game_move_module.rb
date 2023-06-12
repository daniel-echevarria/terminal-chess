
module MovePiece

  DIRECTIONS = {
    up: [-1, 0],
    down: [1, 0],
    left: [0, -1],
    right: [0, 1],
    main_diag_up: [-1, -1],
    main_diag_down: [1, 1],
    sec_diag_up: [-1, 1],
    sec_diag_down: [1, -1],
  }

  def move_one(position, direction)
    dir = DIRECTIONS[direction]
    row, col = position.dup

    row += dir[0]
    col += dir[1]

    [row, col]
  end


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
