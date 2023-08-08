require_relative '../lib/game.rb'
require_relative '../lib/player.rb'
require_relative '../lib/piece.rb'
require_relative '../lib/board.rb'

describe ChessGame do
  let(:board) { double('board') }
  let(:player_1) { instance_double(ChessPlayer, color: :white) }
  let(:player_2) { instance_double(ChessPlayer, color: :black) }
  subject(:game) { described_class.new(board, player_1, player_2) }

  describe "#select_piece_input" do
    context 'when player inputs a valid position' do

      before do
        valid_input = 'a2'
        allow(game).to receive(:select_piece_message)
        allow(game).to receive(:valid_pick?).and_return(true)
        allow(game).to receive(:gets).and_return(valid_input)
      end

      it 'completes loop and does not display error message' do
        error_message = "Please input the position of a #{player_1.color} piece"
        expect(game).not_to receive(:puts).with(error_message)
        game.select_piece_input(player_1)
      end
    end

    context 'when player inputs a invalid position and then a valid position' do

      before do
        invalid_input = 'a'
        valid_input = 'a2'
        allow(game).to receive(:select_piece_message)
        allow(game).to receive(:gets).and_return(invalid_input, valid_input)
        allow(game).to receive(:valid_pick?).and_return(false, true)
      end

      it 'completes loop and display error message once' do
        error_message = "Please input the position of a #{player_1.color} piece"
        expect(game).to receive(:puts).with(error_message).once
        game.select_piece_input(player_1)
      end
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

  describe '#move_piece_input' do
    let(:white_pawn) { instance_double(ChessPiece, specie: :pawn, color: :white, position: [6, 0])}

    context 'when player inputs a valid position to move the piece' do
      before do
        valid_move = 'a3'
        allow(game).to receive(:move_piece_message)
        allow(game).to receive(:valid_move?).and_return(true)
        allow(game).to receive(:gets).and_return(valid_move)
      end

      it 'completes the loop and does not display error message' do
        error_message = 'please input a valid move'
        expect(game).not_to receive(:puts).with(error_message)
        game.move_piece_input(white_pawn)
      end
    end

    context 'when player inputs a invalid move then a valid move' do
      before do
        invalid_move = 'c3'
        valid_move = 'a3'
        allow(game).to receive(:move_piece_message)
        allow(game).to receive(:valid_move?).and_return(false, true)
        allow(game).to receive(:gets).and_return(invalid_move, valid_move)
      end

      it 'completes the loop and display error message once' do
        error_message = 'please input a valid move'
        expect(game).to receive(:puts).with(error_message).once
        game.move_piece_input(white_pawn)
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

  describe '#promotion_input' do
    let(:player) { instance_double(ChessPlayer, name: 'John') }

    context 'when player inputs a valid promotion option' do
      before do
        valid_input = 'rook'
        allow(game).to receive(:display_promotion_message).with(player)
        allow(game).to receive(:gets).and_return(valid_input)
        allow(game).to receive(:valid_promotion?).with(valid_input).and_return(true)
      end

      it 'exits loop and does not display wrong promotion message' do
        expect(game).not_to receive(:display_wrong_promotion)
        game.promotion_input(player)
      end

      it 'returns the input converted to a symbol' do
        result = game.promotion_input(player)
        expect(result).to eq(:rook)
      end
    end

    context 'when player first inputs a invalid promotion and then a valid one' do
      before do
        invalid_input = 'king'
        valid_input = 'rook'
        allow(game).to receive(:display_promotion_message).with(player)
        allow(game).to receive(:gets).and_return(invalid_input, valid_input)
        allow(game).to receive(:valid_promotion?).with(invalid_input).and_return(false)
        allow(game).to receive(:valid_promotion?).with(valid_input).and_return(true)
      end

      it 'exits loop display wrong promotion message once' do
        expect(game).to receive(:display_wrong_promotion).once
        game.promotion_input(player)
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
end
