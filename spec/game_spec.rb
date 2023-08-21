require_relative '../lib/game.rb'
require_relative '../lib/player.rb'
require_relative '../lib/piece.rb'
require_relative '../lib/board.rb'

describe ChessGame do
  let(:board) { double('board') }
  let(:player_1) { instance_double(ChessPlayer, color: :white) }
  let(:player_2) { instance_double(ChessPlayer, color: :black) }
  let(:display) { double('display')}
  subject(:game) { described_class.new(board, player_1, player_2) }

  before do
    game.instance_variable_set(:@display, display)
    allow(board).to receive(:update_board_without_moves)
  end

  describe '#piece_selection_loop' do
    let(:chess_piece) { instance_double(ChessPiece, specie: :pawn, color: :white, position: [7, 0]) }

    before do
      player = player_1
      board.instance_variable_set(:@pieces, [chess_piece])
      allow(display).to receive(:select_piece_message).with(player)
      allow(game).to receive(:valid_pick?).and_return(true)
    end

    context 'when player selects a piece of they color' do
      it 'ends loop and does not display error message' do
        expect(display).not_to receive(:wrong_piece_selection_message)
        game.piece_selection_loop(player_1)
      end
    end

    context 'when player selects an empty square' do

    end
  end

  describe '#valid_pick?' do
    context 'when player is white and picks a white piece' do
      let(:white_pawn) { instance_double(ChessPiece, specie: :pawn, color: :white) }

      before do
        pick = 'a2'
        allow(game).to receive(:translate_chess_to_array).with(pick).and_return([6, 0])
        allow(board).to receive(:select_piece_at).with([6, 0]).and_return(white_pawn)
        allow(white_pawn).to receive(:color).and_return(:white)
      end

      it 'returns true' do
        pick = 'a2'
        result = game.valid_pick?(player_1, pick)
        expect(result).to be(true)
      end
    end

    context 'when player is white and picks a blackpiece' do
      let(:black_pawn) { instance_double(ChessPiece, specie: :pawn, color: :black) }

      before do
        pick = 'a7'
        allow(game).to receive(:translate_chess_to_array).with(pick).and_return([1, 0])
        allow(board).to receive(:select_piece_at).with([1, 0]).and_return(black_pawn)
        allow(black_pawn).to receive(:color).and_return(:black)
      end

      it 'returns false' do
        pick = 'a7'
        result = game.valid_pick?(player_1, pick)
        expect(result).to be(false)
      end
    end
  end

  describe '#moving_piece_loop' do
    let(:white_pawn) { instance_double(ChessPiece, specie: :pawn, color: :white, position: [6, 0])}

    before do
      allow(display).to receive(:move_piece_message)
    end

    context 'when player inputs a valid position to move the piece' do
      before do
        valid_move = 'a3'
        piece = white_pawn
        allow(game).to receive(:gets).and_return(valid_move)
        allow(game).to receive(:valid_move?).with(valid_move, piece).and_return(true)
      end

      it 'completes the loop and does not display error message' do
        expect(display).not_to receive(:wrong_move_message)
        game.moving_piece_loop(white_pawn)
      end
    end

    context 'when player inputs a invalid move then a valid move' do
      before do
        invalid_move = 'c3'
        valid_move = 'a3'
        allow(game).to receive(:gets).and_return(invalid_move, valid_move)
        allow(game).to receive(:valid_move?).and_return(false, true)
      end

      it 'completes the loop and display error message once' do
        invalid_input = 'c3'
        expect(display).to receive(:wrong_move_message).with(invalid_input, white_pawn).once
        game.moving_piece_loop(white_pawn)
      end
    end
  end

  describe '#translate_chess_to_array' do
    context 'when user inputs a2' do
      it 'returns [6, 0]' do
        input = 'a2'
        result = game.translate_chess_to_array(input)
        expect(result).to eq([6, 0])
      end
    end

    context 'when user inputs e3' do
      it 'returns [5, 4]' do
        input = 'e3'
        result = game.translate_chess_to_array(input)
        expect(result).to eq([5, 4])
      end
    end

    context 'when use inputs h8' do
      it 'returns [0, 7]' do
        input = 'h8'
        result = game.translate_chess_to_array(input)
        expect(result).to eq([0, 7])
      end
    end
  end

  describe '#promotion_input_loop' do
    let(:player) { instance_double(ChessPlayer, name: 'John') }

    context 'when player inputs a valid promotion option' do
      before do
        valid_input = 'rook'
        allow(display).to receive(:promotion_message).with(player)
        allow(game).to receive(:gets).and_return(valid_input)
        allow(game).to receive(:valid_promotion?).with(valid_input).and_return(true)
      end

      it 'exits loop and does not display wrong promotion message' do
        expect(display).not_to receive(:wrong_promotion)
        game.promotion_input_loop(player)
      end

      it 'returns the input converted to a symbol' do
        result = game.promotion_input_loop(player)
        expect(result).to eq(:rook)
      end
    end

    context 'when player first inputs a invalid promotion and then a valid one' do
      before do
        invalid_input = 'king'
        valid_input = 'rook'
        allow(display).to receive(:promotion_message).with(player)
        allow(game).to receive(:gets).and_return(invalid_input, valid_input)
        allow(game).to receive(:valid_promotion?).with(invalid_input).and_return(false)
        allow(game).to receive(:valid_promotion?).with(valid_input).and_return(true)
      end

      it 'exits loop display wrong promotion message once' do
        expect(display).to receive(:wrong_promotion).once
        game.promotion_input_loop(player)
      end
    end
  end

  describe '#valid_promotion?' do
    context 'when the input is a valid promotion' do
      context 'when the input is queen' do
        it 'returns true' do
          input = 'queen'
          result = game.valid_promotion?(input)
          expect(result).to eq(true)
        end
      end

      context 'when the input is bishop' do
        it 'returns true' do
          input = 'bishop'
          result = game.valid_promotion?(input)
          expect(result).to eq(true)
        end
      end

      context 'when the input is knight' do
        it 'returns true' do
          input = 'knight'
          result = game.valid_promotion?(input)
          expect(result).to eq(true)
        end
      end

      context 'when the input is rook' do
        it 'returns true' do
          input = 'rook'
          result = game.valid_promotion?(input)
          expect(result).to eq(true)
        end
      end
    end

    context 'when the input is not a valid promotion' do
      context 'when the input is roo' do
        it 'returns false' do
          input = 'roo'
          result = game.valid_promotion?(input)
          expect(result).to eq(false)
        end
      end

      context 'when the input is king' do
        it 'returns false' do
          input = 'king'
          result = game.valid_promotion?(input)
          expect(result).to eq(false)
        end
      end
    end
  end

  describe '#castling?' do
    context 'when the piece is a king and moved 2 squares' do
      it 'returns true' do
        piece = ChessPiece.new(:king, [7, 4], :white)
        target_position = [7, 6]
        result = game.castling?(piece, target_position)
        expect(result).to eq(true)
      end
    end

    context 'when the piece is not a king' do
      it 'returns false' do
        piece = ChessPiece.new(:rook, [7, 4], :white)
        target_position = [7, 6]
        result = game.castling?(piece, target_position)
        expect(result).to eq(false)
      end
    end

    context 'when the king did not move more than one square' do
      it 'returns false' do
        piece = ChessPiece.new(:king, [7, 4], :white)
        target_position = [7, 5]
        result = game.castling?(piece, target_position)
        expect(result).to eq(false)
      end
    end
  end

  describe '#can_somebody_win?' do
    context 'when there is less than 5 pieces and none of the pieces is a winable' do
      let(:knight) { instance_double(ChessPiece, specie: :knight) }
      let(:king) { instance_double(ChessPiece, specie: :king) }
      let(:bishop) { instance_double(ChessPiece, specie: :bishop) }
      let(:king2) { instance_double(ChessPiece, specie: :king2) }

      before do
        allow(board).to receive(:count_pieces).and_return(4)
        allow(board).to receive(:pieces).and_return([knight, king, bishop])
        allow(knight).to receive(:winable_piece?).and_return(false)
        allow(king).to receive(:winable_piece?).and_return(false)
        allow(bishop).to receive(:winable_piece?).and_return(false)
        allow(king2).to receive(:winable_piece?).and_return(false)
      end

      it 'returns false' do
        result = game.can_somebody_win?
        expect(result).to eq(false)
      end
    end
  end
end
