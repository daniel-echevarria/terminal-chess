require_relative '../lib/chess_game_tower.rb'
require_relative '../lib/chess_game_move_module.rb'

describe ChessTower do
  subject(:tower) { described_class.new([2, 2], 'black')}

  # describe 'potential moves' do
  #   describe 'when tower is black and on [2, 2] position' do

  #     xit 'returns 14 potential moves' do
  #       result = tower.potential_moves
  #       expect(result.length).to eq(14)
  #     end
  #   end
  # end

  describe 'list_up_vertical_moves' do
    context 'when tower is on [2, 2] position' do
      it 'returns [[1, 2], [0, 2]]' do
        result = tower.list_up_vertical_moves
        expectation = [[1, 2], [0, 2]]
        expect(result).to eq(expectation)
      end
    end

    context 'when tower is on [7, 0]' do
      let(:tower) { described_class.new([7, 0], 'white') }

      it  'returns [[6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [0, 0]]' do
        result  = tower.list_up_vertical_moves
        expectation = [[6, 0], [5, 0], [4, 0], [3, 0], [2, 0], [1, 0], [0, 0]]
        expect(result).to eq(expectation)
      end
    end
  end
end
