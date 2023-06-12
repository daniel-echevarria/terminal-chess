require_relative '../../lib/chess_game/move_generator.rb'
require_relative '../../lib/chess_game/chess_game_board.rb'
require_relative '../../lib/chess_pieces/chess_piece.rb'
require_relative '../../lib/chess_game/chess_game_move_module'

describe MoveGenerator do
  include MovePiece

  let(:white_piece) { instance_double(ChessPiece, position: [4, 3], color: 'white') }
  let(:white_ally) { instance_double(ChessPiece, position: [4, 4], color: 'white') }
  let(:black_piece) { instance_double(ChessPiece, position: [3, 3], color: 'black') }
  let(:board) { instance_double(ChessBoard) }
  subject(:move_generator) { described_class.new(white_piece, board)}

  before do
    board.instance_variable_set(:@pieces, [white_piece, black_piece])
  end

  describe '#position_is_free?' do
    context 'when the cell is free' do

      before do
        allow(board).to receive(:pieces).and_return([white_piece, white_ally, black_piece])
      end

      it 'returns true' do
        position = [2, 2]
        result = move_generator.position_is_free?(position)
        expect(result).to eq(true)
      end
    end

    context 'when there is an opponent' do
      it 'returns false' do
      end
    end

    context 'when there is an ally' do
      it 'returns false' do
      end
    end
  end

  describe '#invalid_move?' do
    context 'when the position has an ally on it' do

      before do
        position = white_ally.position
        allow(move_generator).to receive(:select_piece_at).with(position).and_return(white_ally)
      end

      it 'returns false' do
        position = [4, 4]
        result = move_generator.invalid_move?(position)
        expect(result).to eq(true)
      end
    end

    context 'when the position is out of board' do

      before do
        position = [-1, 4]
        allow(move_generator).to receive(:select_piece_at).with(position).and_return(nil)
      end

      it 'returns false' do
        position = [-1, 4]
        result = move_generator.invalid_move?(position)
        expect(result).to eq(true)
      end
    end
  end

  describe '#generate_pawn_moves' do
    context 'when its a white pawn on [6, 1] and there are no opponents around'  do
      let(:white_pawn) { instance_double(ChessPawn, color: 'white', position: [6, 1]) }
      let(:board) { instance_double(ChessBoard) }
      subject(:move_generator) { described_class.new(white_pawn, board)}

      before do
        main_diag = [5, 0]
        sec_diag = [5, 2]
        one_front = [5, 1]
        two_front = [4, 1]
        allow(move_generator).to receive(:has_oponent).with(main_diag).and_return(false)
        allow(move_generator).to receive(:has_oponent).with(sec_diag).and_return(false)
        allow(move_generator).to receive(:position_is_free?).with(one_front).and_return(true)
        allow(move_generator).to receive(:position_is_free?).with(two_front).and_return(true)
        allow(white_pawn).to receive(:on_initial_position?).and_return(true)
      end

      it 'returns the 2 positions in front of the pawn' do
        result = move_generator.generate_pawn_moves
        expectation = [[5, 1], [4, 1]]
        expect(result).to eq(expectation)
      end
    end
  end

  describe '#generate_rook_moves' do
    context 'when the rook is white and on [4, 3]' do
      let(:rook) { instance_double(ChessRook, color: 'white', position: [4, 3]) }

      context 'when there are no pieces on the way' do
        xit 'returns 14 possible moves' do
          result = move_generator.generate_rook_moves
          expect(result.length).to eq(14)
        end
      end
    end
  end

  describe '#generate_moves' do
    context 'when the piece is a white rook on [4, 2]' do
      let(:rook) { instance_double(ChessRook, color: 'white', position: [4, 2]) }

      context 'when the direction is up and there are no pieces on the way' do

        before do
          allow(board).to receive(:pieces).and_return([rook])
        end

        it 'returns [[3, 2], [2, 2], [1, 2], [0, 2]]' do
          direction = [-1, 0]
          result = move_generator.generate_moves(rook, direction)
          expectation = [[3, 2], [2, 2], [1, 2], [0, 2]]
          expect(result).to eq(expectation)
        end
      end

      context 'when the direction is right and there is an ally on [4, 6]' do
        let(:white_piece) { instance_double(ChessPiece, color: 'white', position: [4, 6])}

        before do
          allow(board).to receive(:pieces).and_return([rook, white_piece])
        end

        it 'returns [[4, 3], [4, 4], [4, 5]]' do
          direction = [0, 1]
          result = move_generator.generate_moves(rook, direction)
          expectation = [[4, 3], [4, 4], [4, 5]]
          expect(result).to eq(expectation)
        end
      end
    end
  end

  describe '#select_direction' do
    context 'when the direction symbole is :up' do
      it 'returns [-1, 0]' do
        direction = :up
        result = move_generator.select_direction(direction)
        expect(result).to eq([-1, 0])
      end
    end
  end

  describe '#generate_up_vertical_moves' do
    context 'when the rook is white and on [4, 3]' do
      let(:rook) { instance_double(ChessRook, color: 'white', position: [4, 3]) }
      let(:white_piece) { instance_double(ChessPiece, color: 'white') }
      let(:board) { instance_double(ChessBoard) }
      let(:move_generator) { described_class.new(rook, board)}

      context 'when there are no pieces on the way' do

        before do
          allow(board).to receive(:select_piece_at).and_return(nil)
        end

        xit 'returns [[3, 3], [2, 3], [1, 3], [0, 3]]' do
          result = move_generator.generate_up_vertical_moves(rook)
          expectation = [[3, 3], [2, 3], [1, 3], [0, 3]]
          expect(result).to eq(expectation)
        end
      end

      context 'when there is an ally on [1, 3]' do

        before do
          allow(board).to receive(:select_piece_at).and_return(nil)
          allow(board).to receive(:select_piece_at).with([1, 3]).and_return(white_piece)
        end

        xit 'returns [[3, 3], [2, 3]]' do
          result = move_generator.generate_up_vertical_moves(rook)
          expectation = [[3, 3], [2, 3]]
          expect(result).to eq(expectation)
        end
      end
    end
  end

  describe '#generate_possible_moves' do
    context 'when the piece is a white pawn' do
      let(:white_pawn) { instance_double(ChessPawn, color: 'white') }
      let(:board) { instance_double(ChessBoard) }
      subject(:move_generator) { described_class.new(white_pawn, board)}

      context 'when the pawn is on inital position and there are no opponents around' do

        before do
          white_pawn.instance_variable_set(:@position, [6, 1])
          allow(white_pawn).to receive(:class).and_return(ChessPawn)
          allow(move_generator).to receive(:generate_pawn_moves).and_return([[5, 1], [4, 1]])
        end

        it 'returns the 2 positions in front of the pawn' do
          result = move_generator.generate_possible_moves
          expectation = [[5, 1], [4, 1]]
          expect(result).to eq(expectation)
        end
      end
    end
  end


end
