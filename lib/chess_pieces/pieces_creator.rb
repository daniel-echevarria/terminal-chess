require_relative 'chess_piece.rb'


class ChessPiecesCreator
  PIECES_INITIAL_SETUP = {
    rook: {
      specie: :rook,
      positions: [[0, 0], [0, 7], [7, 0], [7, 7]],
      unicodes: ["\u265C", "\u2656"]
    },
    knight: {
      specie: :knight,
      positions: [[0, 1], [0, 6], [7, 1], [7, 6]],
      unicodes: ["\u265E", "\u2658"]
    },
    bishop: {
      specie: :bihsop,
      positions: [[0, 2], [0, 5], [7, 2], [7, 5]],
      unicodes: ["\u265D", "\u2657"]
    },
    queen: {
      specie: :queen,
      positions: [[0, 3], [7, 3]],
      unicodes: ["\u265B", "\u2655"]
    },
    king: {
      specie: :king,
      positions: [[0, 4], [7, 4]],
      unicodes: ["\u265A", "\u2654"]
    },
    pawn: {
      specie: :pawn,
      positions: [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7],
      [6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7]],
      unicodes: ["\u265F", "\u2659"]
    }
  }

  attr_accessor :pieces

  def initialize
    @pieces = create_all_pieces
  end

  # given a piece type a position and a color
  # create a piece of that type at that position with the right color and unicode

  def create_piece_at_position(type, position, color)
    major = PIECES_INITIAL_SETUP[type]
    unicodes = major[:unicodes]
    specie = major[:specie]

    unicode = assign_piece_unicode(color, unicodes)
    ChessPiece.new(specie, position, color, unicode)
  end

  def create_one_type_of_pieces(type)
    specie = type[:specie]
    positions = type[:positions]
    unicodes = type[:unicodes]

    pieces = positions.map do |pos|
      color = assign_piece_color(pos)
      unicode = assign_piece_unicode(color, unicodes)
      ChessPiece.new(specie, pos, color, unicode)
    end
  end

  def assign_piece_color(position)
    row = position[0]
    row < 3 ? :black : :white
  end

  def assign_piece_unicode(color, unicodes)
    color ==  :white ? unicodes[0] : unicodes[1]
  end

  def create_all_pieces
    pieces = []
    PIECES_INITIAL_SETUP.values.each do |type|
      pieces << create_one_type_of_pieces(type)
    end
    pieces.flatten(1)
  end
end
