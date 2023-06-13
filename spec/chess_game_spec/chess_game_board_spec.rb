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
    let(:white_pawn) { instance_double(ChessPawn, color: 'white', position: [0, 6]) }

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

  describe '#create_one_type_of_pieces' do
    context 'when passed the rook hash' do
      it 'creates a rook for each initial position' do
        rook_hash = { constructor: ChessRook,
          positions: [[0, 0], [0, 7], [7, 0], [7, 7]],
          unicodes: ["\u265C", "\u2656"]
         }
        result = chess_board.create_one_type_of_pieces(rook_hash)
        expect(result).to include(an_instance_of(ChessRook)).exactly(4).times
      end
    end
  end

  describe '#create_all_pieces' do
    context 'when passed a specific hash containing all the needed info' do
      it 'creates 32 pieces' do
        hash = ChessBoard::MAJOR_PIECES_INITIAL_SETUP
        result = chess_board.create_all_pieces
        expect(result).to include(ChessPiece).exactly(32).times
      end
    end
  end

  describe '#assign_piece_color' do
    context 'when the piece is on the upper half of the board' do
      it 'returns black' do
        position = [0, 1]
        result = chess_board.assign_piece_color(position)
        expect(result).to eq('black')
      end
    end

    context 'when the piece is on the lower half of the board' do
      it 'returns white' do
        position = [6, 0]
        result = chess_board.assign_piece_color(position)
        expect(result).to eq('white')
      end
    end
  end

  describe '#assign_piece_unicode' do
    context 'when the piece is white' do

      it 'assigns the first unicode in the unicodes array' do
        unicodes = ["\u265C", "\u2656"]
        color = 'white'
        result = chess_board.assign_piece_unicode(color, unicodes)
        expect(result).to eq("\u265C")
      end
    end

    context 'when the piece is black' do

      it 'assigns the first unicode in the unicodes array' do
        unicodes = ["\u265C", "\u2656"]
        color = 'black'
        result = chess_board.assign_piece_unicode(color, unicodes)
        expect(result).to eq("\u2656")
      end
    end
  end

  describe '#select_opponent_pieces' do
    let(:white_piece) { instance_double(ChessPiece, color: 'white') }
    let(:white_piece_2) { instance_double(ChessPiece, color: 'white') }
    let(:black_piece_one) { instance_double(ChessPiece, color: 'black') }
    let(:black_piece_2) { instance_double(ChessPiece, color: 'black') }

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
      let(:white_piece) { instance_double(ChessPiece, color: 'white', position: [3, 2]) }
      let(:black_rook) { instance_double(ChessRook, color: 'black', position: [3, 4]) }
      let(:black_knight) { instance_double(ChessKnight, color: 'black', position: [5, 6]) }

      before do
        chess_board.instance_variable_set(:@pieces, [white_piece, black_rook, black_knight])
        allow(chess_board).to receive(:select_opponent_pieces).and_return([black_rook, black_knight])
        allow(black_rook).to receive(:class).and_return(ChessRook)
        allow(black_knight).to receive(:class).and_return(ChessKnight)
      end

      it 'returns all the possible moves of the black pieces' do
        result = chess_board.get_opponent_possible_moves(white_piece)
        expect(result.length).to eq(18)
      end
    end
  end

  describe '#is_check?' do
    context 'when '
  end
end
