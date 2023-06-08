require_relative '../../lib/chess_game/chess_game_board.rb'

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

  describe '#create_pieces' do
    context 'when passed the rook hash' do
      it 'creates a rook for each initial position' do
        rook_hash = { constructor: ChessRook,
          positions: [[0, 0], [0, 7], [7, 0], [7, 7]],
          unicodes: ["\u265C", "\u2656"]
         }
        result = chess_board.create_pieces(rook_hash)
        expect(result).to include(an_instance_of(ChessRook)).exactly(4).times
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
end
