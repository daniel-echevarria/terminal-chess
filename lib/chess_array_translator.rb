
module ChessArrayTranslator

  CHESS_ROWS = 8.downto(1).to_a
  CHESS_COLUMNS = 'a'.upto('h').to_a

  def translate_chess_to_array(chess_notation)
    column, row = chess_notation.split('')
    a_column = CHESS_COLUMNS.index(column)
    a_row = CHESS_ROWS.index(row.to_i)
    [a_row, a_column]
  end

  def translate_array_to_chess(array_notation)
    row, column = array_notation
    c_row = CHESS_ROWS[row]
    c_column = CHESS_COLUMNS[column]
    [c_column, c_row].join
  end
end
