require_relative '../lib/chess_game_move_module.rb'

describe MovePiece do

  let(:dummy_class) { Class.new { include MovePiece }}
  let(:dummy_instance) { dummy_class.new }

  describe '#move_vertically' do
    context 'when asked to move 2 squares up' do
      context 'when position is [6, 0]' do
        it 'returns [4, 0]' do
          move_value = -2
          position = [6, 0]
          result = dummy_instance.move_vertically(position, move_value)
          expect(result).to eq([4, 0])
        end
      end
    end

    context 'when asked to move 3 squares down' do
      context 'when position is [1, 3]' do
        it 'returns [4, 3]' do
          move_value = 3
          position = [1, 3]
          result = dummy_instance.move_vertically(position, move_value)
          expect(result).to eq([4, 3])
        end
      end
    end
  end
end
