require_relative '../lib/chess_game_move_generator.rb'
require_relative '../lib/chess_game_board.rb'
require_relative '../lib/chess_game_pawn.rb'
require_relative '../lib/chess_game_tower.rb'
require_relative '../lib/chess_game_move_module.rb'


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

  describe '#has_ally' do
    let(:whitepawn) { instance_double(ChessPawn, color: 'white', position: [6, 0]) }
    let(:whitepawn_2) { instance_double(ChessPawn, color: 'white', position: [5, 0]) }
    let(:blackpawn) { instance_double(ChessPawn, color: 'black', position: [4, 0]) }

    before do
      position = [5, 0]
      allow(generator).to receive(:select_piece_at).with(position).and_return(whitepawn_2)
    end

    context 'when there is an ally at the position' do
      it 'returns true' do
        position = [5, 0]
        result = generator.has_ally(whitepawn, position)
        expect(result).to be(true)
      end
    end
  end

  describe '#is_out_of_board?' do
    context 'when the position is out of board' do
      context 'when the position is too far up' do
        it 'returns true' do
          position = [-1, 5]
          result = generator.is_out_of_board?(position)
          expect(result).to eq(true)
        end
      end

      context 'when the position is too far down' do
        it 'returns true ' do
          position = [8, 5]
          result = generator.is_out_of_board?(position)
          expect(result).to eq(true)
        end
      end

      context 'when the positon is too far left' do
        it 'returns true' do
          position = [3, -1]
          result = generator.is_out_of_board?(position)
          expect(result).to eq(true)
        end
      end

      context 'when the position is too far right' do
        it 'returns true' do
          position = [3, 8]
          result = generator.is_out_of_board?(position)
          expect(result).to eq(true)
        end
      end

      context 'when the position is not out of board' do
        it 'returns false' do
          position = [3, 7]
          result = generator.is_out_of_board?(position)
          expect(result).to eq(false)
        end
      end
    end

    describe '#generate_up_vertical_moves' do
      let(:tower) { instance_double(ChessTower, color: 'white', position: [4, 3]) }

      context 'when the piece is a white tower on d4 ([4, 3]) and there is nothing on the way' do
        it 'returns [[3, 3], [2, 3], [1, 3] [0, 3]]' do
          result = generator.generate_up_vertical_moves(tower)
          expectation = [[3, 3], [2, 3], [1, 3], [0, 3]]
          expect(result).to eq(expectation)
        end
      end

      context 'when the piece is a white tower on a3 [5, 0] and a black pawn on [1, 0]' do
        let(:white_tower) { instance_double(ChessTower, color: 'white', position: [5, 0])}
        let(:black_pawn) { instance_double(ChessPawn, color: 'black', position: [1, 0])}

        before do
          generator.pieces << black_pawn
        end

        it 'returns [[4, 0], [3, 0], [2, 0], [1, 0]]' do
          result = generator.generate_up_vertical_moves(white_tower)
          expectation = [[4, 0], [3, 0], [2, 0], [1, 0]]
          expect(result).to eq(expectation)
        end
      end
    end

    describe '#generate_down_vertical_moves' do
      let(:tower) { instance_double(ChessTower, color: 'white', position: [3, 2]) }
      let(:whitepawn) { instance_double(ChessPawn, color: 'white', position: [6, 2]) }

      before do
        generator.pieces << whitepawn
      end

      context 'when the piece is a white tower on c5 ([3, 2]) and there is a white pawn on [6, 2]' do
        it 'returns [[4, 2], [5, 2]]' do
          result = generator.generate_down_vertical_moves(tower)
          expectation = [[4, 2], [5, 2]]
          expect(result).to eq(expectation)
        end
      end

      context 'when the piece is a black tower on a3 [5, 0]' do
        let(:black_tower) { instance_double(ChessTower, color: 'black', position: [5, 0])}

        it 'returns [[6, 0]]' do
          result = generator.generate_down_vertical_moves(black_tower)
          expectation = [[6, 0]]
          expect(result).to eq(expectation)
        end
      end
    end

    describe '#generate_left_horizontal_moves' do
      let(:white_tower) { instance_double(ChessTower, color: 'white', position: [4, 4]) }
      let(:whitepawn) { instance_double(ChessPawn, color: 'white', position: [4, 0]) }

      before do
        generator.pieces << whitepawn
      end

      after do
        generator.pieces.delete(whitepawn)
      end

      context 'when the piece on [4, 4] (e4) and there is a ally on [4, 0]' do
        it 'returns [[4, 3], [4, 2], [4, 1]]' do
          result = generator.generate_left_horizontal_moves(white_tower)
          expectation = [[4, 3], [4, 2], [4, 1]]
          expect(result).to eq(expectation)
        end
      end
    end
  end
end
