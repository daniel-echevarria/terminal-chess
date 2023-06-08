require_relative '../../lib/chess_game/chess_game_move_module.rb'

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

  describe '#move_horizontally' do
    context 'when asked to move 2 squares to the right' do
      context 'when position is [4, 3]' do
        it 'returns [4, 5]' do
          move_value = 2
          position = [4, 3]
          result = dummy_instance.move_horizontally(position, move_value)
          expect(result).to eq([4, 5])
        end
      end
    end

    context 'when asked to move 4 squares to the left' do
      context 'when position is [2, 6]' do
        it 'returns [2, 2]' do
          move_value = -4
          position = [2, 6]
          result = dummy_instance.move_horizontally(position, move_value)
          expect(result).to eq([2, 2])
        end
      end
    end
  end

  describe '#move_main_diagonal' do
    context 'when asked to move 3 squares up' do
      context 'when position is [3, 3]' do
        it 'returns [6, 6]' do
          move_value = 3
          position = [3, 3]
          result = dummy_instance.move_main_diagonal(position, move_value)
          expect(result).to eq([0, 0])
        end
      end
    end

    context 'when asked to move 2 squares down' do
      context 'when position is [5, 5]' do
        it 'returns [7, 7]' do
          move_value = -2
          position = [5, 5]
          result = dummy_instance.move_main_diagonal(position, move_value)
          expect(result).to eq([7, 7])
        end
      end
    end
  end

  describe '#move_secondary_diagonal' do
    context 'when asked to move 2 squares up' do
      context 'when position is [2, 3]' do
        it 'returns [0, 5]' do
          move_value = 2
          position = [2, 3]
          result = dummy_instance.move_secondary_diagonal(position, move_value)
          expect(result).to eq([0, 5])
        end
      end
    end

    context 'when asked to move 2 squares down' do
      context 'when position is [3, 3]' do
        it 'returns [5, 1]' do
          move_value = -2
          position = [3, 3]
          result = dummy_instance.move_secondary_diagonal(position, move_value)
          expect(result).to eq([5, 1])
        end
      end
    end
  end
end
