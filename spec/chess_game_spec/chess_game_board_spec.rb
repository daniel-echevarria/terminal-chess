require_relative '../../lib/chess_game/chess_game_board.rb'
require_relative '../../lib/chess_pieces/chess_piece.rb'

describe ChessBoard do

  subject(:chess_board) { described_class.new}

  describe '#create_board' do
    it 'creates a 8x8 empty board' do
      result = chess_board.create_board
      expect(result).to eq([
        [" ", " ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " ", " "],
        [" ", " ", " ", " ", " ", " ", " ", " "],
      ])
    end
  end

  describe '#position_is_free?' do
    context 'when the cell is free' do
      it 'returns true' do
        position = [2, 2]
        result = chess_board.position_is_free?(position)
        expect(result).to eq(true)
      end
    end

    context 'when there is an opponent' do
      xit 'returns false' do
      end
    end

    context 'when there is an ally' do
      xit 'returns false' do
      end
    end
  end

  describe '#clean_cell' do
    context 'when there is a piece in the cell' do

      before do
        chess_board.board[0][6] = 'p'
      end

      it 'changes the value of the cell from the piece to a string with one space' do
        position = [0, 6]
        expect { chess_board.clean_cell(position) }.to change { chess_board.board[0][6] }.from('p').to(' ')
      end
    end
  end

  describe '#select_piece_at' do
    let(:white_pawn) { instance_double(ChessPiece, color: :white, position: [0, 6]) }

    before do
      chess_board.instance_variable_set(:@pieces, [white_pawn])
    end

    context 'when the positions is [0, 6] and there is a pawn on that position' do
      it 'returns the pawn' do
        position = [0, 6]
        result = chess_board.select_piece_at(position)
        expect(result).to eq(white_pawn)
      end
    end

    context 'when the position is [0, 5] and there is no piece on that position' do
      it 'returns nil' do
        position = [0, 5]
        result = chess_board.select_piece_at(position)
        expect(result).to be_nil
      end
    end
  end

  describe '#select_opponent_pieces' do
    let(:white_piece) { instance_double(ChessPiece, color: :white) }
    let(:white_piece_2) { instance_double(ChessPiece, color: :white) }
    let(:black_piece_one) { instance_double(ChessPiece, color: :black) }
    let(:black_piece_2) { instance_double(ChessPiece, color: :black) }

    context 'when the piece is white and there are 2 black pieces and one other white piece' do

      before do
        chess_board.instance_variable_set(:@pieces, [black_piece_one, black_piece_2, white_piece_2, white_piece])
      end

      it 'return an array with all the black pieces' do
        result = chess_board.select_opponent_pieces(white_piece)
        expect(result).to eq([black_piece_one, black_piece_2])
      end
    end
  end

  describe '#get_opponent_possible_moves' do
    context 'when the piece is white and there are 3 black pieces on the board' do
      let(:white_piece) { instance_double(ChessPiece, color: :white, position: [3, 2]) }
      let(:black_rook) { instance_double(ChessRook, color: :black, position: [3, 4]) }
      let(:black_knight) { instance_double(ChessKnight, color: :black, position: [5, 6]) }

      before do
        chess_board.instance_variable_set(:@pieces, [white_piece, black_rook, black_knight])
        allow(chess_board).to receive(:select_opponent_pieces).and_return([black_rook, black_knight])
        allow(black_rook).to receive(:class).and_return(ChessRook)
        allow(black_knight).to receive(:class).and_return(ChessKnight)
      end

      xit 'returns all the possible moves of the black pieces' do
        result = chess_board.get_opponent_possible_moves(white_piece)
        expect(result.length).to eq(18)
      end
    end
  end

  describe '#is_check?' do
    context 'when some of the opponents possible moves include the kings position' do
      let(:white_king) { instance_double(ChessKing, color: :white, position: [4, 2])}
      let(:black_rook) { instance_double(ChessRook, color: :black, position: [4, 6])}

      before do
        # chess_board.instance_variable_set(:@pieces, [white_king, black_rook])
        rook_possibles = [[4, 1], [3, 2], [4, 2]]
        allow(chess_board).to receive(:get_opponent_possible_moves).with(white_king).and_return(rook_possibles)
      end

      xit 'returns true' do
        result = chess_board.is_check?(white_king)
        expect(result).to eq(true)
      end
    end
  end

# describe '#create_major_like_pawn' do
#     let(:white_pawn) { instance_double(ChessPiece, color: :white, position: [0, 0]) }
#     let(:piece_creator) { instance_double(ChessPiecesCreator) }

#     context 'when the major is a queen and the pawn is white  on 0, 0' do

#       before do
#         chess_board.instance_variable_set(:@pieces, [white_pawn])
#         # allow(white_pawn).to receive(:position).with([-1, -1])
#       end

#       it 'returns a queen' do
#         type = :queen
#         major = chess_board.create_major_like_pawn(type, white_pawn)
#         result = major.specie == :queen
#         expect(result).to eq(true)
#       end

#       it 'gives it a position of [0, 0]' do
#         type = :queen
#         major = chess_board.create_major_like_pawn(type, white_pawn)
#         result = major.position
#         expect(result).to eq([0, 0])
#       end

#       it 'gives it a white color' do
#         type = :queen
#         major = chess_board.create_major_like_pawn(type, white_pawn)
#         result = major.color
#         expect(result).to eq(:white)
#       end

#       it 'gives it the right unicode' do
#         type = :queen
#         major = chess_board.create_major_like_pawn(type, white_pawn)
#         result = major.unicode
#         expect(result).to eq("\u265B")
#       end
#     end
#   end
end
