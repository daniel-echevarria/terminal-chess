
require_relative '../lib/chess_game_pawn.rb'

class ChessBoard

  def initialize
    @board = create_board
    @pawns = create_pawns
    @board_pieces = []
  end

  def create_board
    Array.new(8) { Array.new(8, " ") }
  end

  def create_pawns
    pawns = []
    (0..7).each_with_index do |num, index|
      pawns << ChessPawn.new([1, index], 'black')
      pawns << ChessPawn.new([6, index], 'white')
    end
    pawns
  end

  def populate_board
    @pawns.each do |pawn|
      row, col = pawn.position
      @board[row][col] = pawn.unicode
    end
  end

  def display_board
    i = 8
    @board.each do |row|
      puts " #{i}  #{row.join(' | ')} "
      puts '   -------------------------------'
      i -= 1
    end
    p "   #{('a'..'h').to_a.join('   ')}"
  end
end

chess_board = ChessBoard.new

chess_board.populate_board
chess_board.display_board

