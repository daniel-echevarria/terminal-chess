require_relative '../chess_pieces/chess_rook.rb'
require_relative '../chess_pieces/chess_knight.rb'
require_relative '../chess_pieces/chess_bishop.rb'
require_relative '../chess_pieces/chess_queen.rb'
require_relative '../chess_pieces/chess_king.rb'
require_relative '../chess_pieces/chess_pawn.rb'

class ChessPiecesCreator
  MAJOR_PIECES_INITIAL_SETUP = {
    rooks: {
      constructor: ChessRook,
      positions: [[0, 0], [0, 7], [7, 0], [7, 7]],
      unicodes: ["\u265C", "\u2656"]
    },
    knights: {
      constructor: ChessKnight,
      positions: [[0, 1], [0, 6], [7, 1], [7, 6]],
      unicodes: ["\u265E", "\u2658"]
    },
    bishops: {
      constructor: ChessBishop,
      positions: [[0, 2], [0, 5], [7, 2], [7, 5]],
      unicodes: ["\u265D", "\u2657"]
    },
    queens: {
      constructor: ChessQueen,
     positions: [[0, 3], [7, 3]],
      unicodes: ["\u265B", "\u2655"]
    },
    kings: {
      constructor: ChessKing,
      positions: [[0, 4], [7, 4]],
      unicodes: ["\u265A", "\u2654"]
    },
    pawns: {
      constructor: ChessPawn,
      positions: [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7],
      [6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7]],
      unicodes: ["\u265F", "\u2659"]
    }
  }


end
