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
end
