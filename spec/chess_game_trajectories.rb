require_relative '../lib/chess_game_trajectories.rb'

describe '#generate_trajectory' do
  subject(:vertical_trajectory) { described_class([7, 0], 'vertical', [4, 0])}
  context 'when start position is [7, 0] direction is vertical and end position is [4, 0]' do
    it 'returns [[6, 0], [5, 0], [3, 0]]' do
      start_position = [7, 0]
      direction = 'vertical'
      end_position = [4, 0]
      result = vertical_trajectory.generate_trajectory(start_position, direction, end_position)
    end
  end
end
