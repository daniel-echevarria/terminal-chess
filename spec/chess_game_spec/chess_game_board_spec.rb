require_relative '../../lib/chess_game/chess_game_board.rb'
require_relative '../../lib/chess_pieces/chess_piece.rb'

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

  describe '#position_is_free?' do
    context 'when the cell is free' do
      it 'returns true' do
        position = [2, 2]
        result = chess_board.position_is_free?(position)
        expect(result).to eq(true)
      end
    end

    context 'when there is an opponent' do
      xit 'returns false' do
      end
    end

    context 'when there is an ally' do
      xit 'returns false' do
      end
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

  describe '#select_piece_at' do
    let(:white_pawn) { instance_double(ChessPiece, color: :white, position: [0, 6]) }

    before do
      chess_board.instance_variable_set(:@pieces, [white_pawn])
    end

    context 'when the positions is [0, 6] and there is a pawn on that position' do
      it 'returns the pawn' do
        position = [0, 6]
        result = chess_board.select_piece_at(position)
        expect(result).to eq(white_pawn)
      end
    end

    context 'when the position is [0, 5] and there is no piece on that position' do
      it 'returns nil' do
        position = [0, 5]
        result = chess_board.select_piece_at(position)
        expect(result).to be_nil
      end
    end
  end

  describe '#select_pieces_of_color' do
    let(:white_piece) { instance_double(ChessPiece, color: :white) }
    let(:white_piece_2) { instance_double(ChessPiece, color: :white) }
    let(:black_piece_one) { instance_double(ChessPiece, color: :black) }
    let(:black_piece_2) { instance_double(ChessPiece, color: :black) }

    context 'when the piece is white and there are 2 black pieces and one other white piece' do

      before do
        chess_board.instance_variable_set(:@pieces, [black_piece_one, black_piece_2, white_piece_2, white_piece])
      end

      it 'return an array with only the black pieces' do
        color = :black
        result = chess_board.select_pieces_of_color(color)
        expect(result).to eq([black_piece_one, black_piece_2])
      end
    end
  end

  describe '#get_opponent_possible_moves' do
    context 'when the piece is white and there are 3 black pieces on the board' do
      let(:white_piece) { instance_double(ChessPiece, color: :white, position: [3, 2]) }
      let(:black_rook) { instance_double(ChessRook, color: :black, position: [3, 4]) }
      let(:black_knight) { instance_double(ChessKnight, color: :black, position: [5, 6]) }

      before do
        chess_board.instance_variable_set(:@pieces, [white_piece, black_rook, black_knight])
        allow(chess_board).to receive(:select_opponent_pieces).and_return([black_rook, black_knight])
        allow(black_rook).to receive(:class).and_return(ChessRook)
        allow(black_knight).to receive(:class).and_return(ChessKnight)
      end

      xit 'returns all the possible moves of the black pieces' do
        result = chess_board.get_opponent_possible_moves(white_piece)
        expect(result.length).to eq(18)
      end
    end
  end

  describe '#is_check?' do
    context 'when some of the opponents possible moves include the kings position' do
      let(:white_king) { instance_double(ChessKing, color: :white, position: [4, 2])}
      let(:black_rook) { instance_double(ChessRook, color: :black, position: [4, 6])}

      before do
        # chess_board.instance_variable_set(:@pieces, [white_king, black_rook])
        rook_possibles = [[4, 1], [3, 2], [4, 2]]
        allow(chess_board).to receive(:get_opponent_possible_moves).with(white_king).and_return(rook_possibles)
      end

      xit 'returns true' do
        result = chess_board.is_check?(white_king)
        expect(result).to eq(true)
      end
    end
  end

  describe '#position_is_threatened' do

    before do
      color = :white
      allow(chess_board).to receive(:get_possible_moves_for_color).with(color).and_return([[2, 1], [2, 2]])
    end

    context 'when the opposite color can snack on that square' do
      it 'returns true' do
        position = [2, 2]
        result = chess_board.position_is_threatened?(position, :white)
        expect(result).to eq(true)
      end
    end

    context 'when the opponent can not snack on that square' do
      it 'returns false' do
        position = [3, 3]
        result = chess_board.position_is_threatened?(position, :white)
        expect(result).to eq(false)
      end
    end
  end

  describe '#piece_moved?' do
    context 'when the piece moved before' do
      it 'returns true' do
      end
    end

    context 'when the piece did not move' do
      it 'returns false' do
      end
    end
  end

  describe '#generate_trajectory' do
    context 'when the start position is [7, 4] and the end position is [7, 7]' do
      it 'returns [[7, 5], [7, 6]]' do
      end
    end
  end
end
