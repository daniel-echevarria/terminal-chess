require_relative '../lib/chess_game_move_generator.rb'


describe MoveGenerator do
  let(:piece) { instance_double(ChessPawn) }
  let(:board) { instance_double(ChessBoard) }
  subject(:generator) { described_class.new(piece, board)}

  describe '#select_piece_at' do
    let(:pawn_1) { instance_double(ChessPawn, position: [6, 0]) }
    let(:pawn_2) { instance_double(ChessPawn, position: [2, 3]) }
    let(:pawn_3) { instance_double(ChessPawn, position: [5, 0]) }

    before do
      board.instance_variable_set(:@pieces, [pawn_1, pawn_2, pawn_3])
    end

    context 'when there is a piece on the selected position' do
      context 'when selected position is [6, 0]' do
        it 'returns the piece on [6, 0]' do
          position = [6, 0]
          result = game.select_piece_at(position)
          expect(result).to eq(pawn_1)
        end
      end

      context 'when selected position is [2, 3]' do
        it 'returns the piece on [2, 3]' do
          position = [2, 3]
          result = game.select_piece_at(position)
          expect(result).to eq(pawn_2)
        end
      end
    end

    context 'when there is no piece on the selected position' do
      context 'when selected position is [4, 2]' do
        it 'returns nil' do
          position = [4, 2]
          result = game.select_piece_at(position)
          expect(result).to eq(nil)
        end
      end
    end
  end
end
