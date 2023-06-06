
require_relative '../lib/chess_game_pawn.rb'

class ChessBoard
  attr_reader :pieces

  def initialize
    @board = create_board
    @pieces = create_pieces
  end

  def create_board
    Array.new(8) { Array.new(8, " ") }
  end

  def update_board
    populate_board(@pieces)
    display_board
  end

  def populate_board(pieces)
    pieces.each do |piece|
      row, col = piece.position
      @board[row][col] = piece.unicode
    end
  end

  def create_pieces
    pieces = []
    pieces << create_pawns
    pieces.flatten(1)
  end

  def create_pawns
    pawns = []
    (0..7).each_with_index do |num, index|
      pawns << ChessPawn.new([1, index], 'black')
      pawns << ChessPawn.new([6, index], 'white')
    end
    pawns
  end

  def clean_cell(position)
    row, col = position
    @board[row][col] = " "
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

