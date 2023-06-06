require_relative '../lib/chess_game_move_generator.rb'
require_relative '../lib/chess_game_board.rb'
require_relative '../lib/chess_game_pawn.rb'


describe MoveGenerator do
  let(:piece) { instance_double(ChessPawn) }
  let(:board) { instance_double(ChessBoard) }
  subject(:generator) { described_class.new(piece, board)}

  let(:white_pawn_a2) { instance_double(ChessPawn, color: 'white', position: [6, 0]) }
  let(:white_pawn_b2) { instance_double(ChessPawn, color: 'white', position: [6, 1]) }
  let(:black_pawn_b7) { instance_double(ChessPawn, color: 'black', position: [1, 1])}
  let(:black_pawn_a3) { instance_double(ChessPawn, color: 'black', position: [5, 0]) }

  before do
    allow(board).to receive(:pieces).and_return( [white_pawn_a2, white_pawn_b2, black_pawn_b7, black_pawn_a3 ]  )
  end

  describe '#select_piece_at' do
    context 'when there is a piece on the selected position' do
      context 'when selected position is [6, 0]' do
        it 'returns the piece on [6, 0]' do
          position = [6, 0]
          result = generator.select_piece_at(position)
          expect(result).to eq(white_pawn_a2)
        end
      end

      context 'when selected position is [6, 1]' do
        it 'returns the piece on [6, 1]' do
          position = [6, 1]
          result = generator.select_piece_at(position)
          expect(result).to eq(white_pawn_b2)
        end
      end
    end

    context 'when there is no piece on the selected position' do
      context 'when selected position is [4, 2]' do
        it 'returns nil' do
          position = [4, 2]
          result = generator.select_piece_at(position)
          expect(result).to eq(nil)
        end
      end
    end
  end

  describe '#has_oponent' do
    context 'when the square has an opponent on it' do
      it 'returns true' do
        position = [1, 1]
        result = generator.has_oponent(white_pawn_a2, position)
        expect(result).to eq(true)
      end
    end

    context 'when the square has no opponent on it' do
      context 'when the square is empty' do
        it 'returns false' do
          position = [4, 0]
          result = generator.has_oponent(white_pawn_a2, position)
          expect(result).to eq(false)
        end
      end

      context 'when the square has a same color piece' do
        it 'returns false' do
          position = white_pawn_b2.position
          result = generator.has_oponent(white_pawn_a2, position)
          expect(result).to eq(false)
        end
      end
    end
  end
end
