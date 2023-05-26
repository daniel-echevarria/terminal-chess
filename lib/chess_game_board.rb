
require_relative '../lib/chess_game_pawn.rb'

class ChessBoard

  def initialize
    @board = create_board
  end

  def create_board
    Array.new(8) { Array.new(8) }
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

  def pre_populate_board
    @board.each_with_index do |row, index|
      if index == 1 || index == 6
        row.map! { |v| v = 'p' }
      end
    end
  end

  def populate_board
    @board.each_with_index do |row, index|
      row.map!.with_index do |col, ind|
        if col == 'p'
          index > 3 ? "\u265F" : "\u2659"
        else
          " "
        end
      end
    end
  end
end

chess_board = ChessBoard.new

chess_board.pre_populate_board
chess_board.populate_board
chess_board.display_board

