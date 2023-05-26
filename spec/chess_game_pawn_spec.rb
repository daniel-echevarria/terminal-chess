require_relative '../lib/chess_game_pawn.rb'
require_relative '../lib/chess_game_move_module.rb'

describe ChessPawn do
  describe '#possible_moves' do
    context 'when pawn is white' do

    subject(:whitepawn) { described_class.new([6, 0], 'white') }

    context 'when on initial position' do

      before do
        position = whitepawn.instance_variable_get(:@position)
        allow(whitepawn).to receive(:initial_position?).and_return(true)
        allow(whitepawn).to receive(:move_vertically).with(position, 1).and_return([5, 0])
        allow(whitepawn).to receive(:move_vertically).with(position, 2).and_return([4, 0])
      end

        it 'returns 2 positions, one or 2 rows down' do
          result = whitepawn.possible_moves.sort
          expectation = [[5, 0], [4, 0]].sort
          expect(result).to eq(expectation)
        end
      end
    end
  end
end
