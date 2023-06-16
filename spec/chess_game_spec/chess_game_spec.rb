require_relative '../../lib/chess_game/chess_game.rb'
require_relative '../../lib/chess_game/chess_game_player.rb'
require_relative '../../lib/chess_game/chess_game_board.rb'
require_relative '../../lib/chess_pieces/chess_pawn.rb'
require_relative '../../lib/chess_pieces/chess_rook.rb'

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
      let(:white_pawn) { instance_double(ChessPawn, color: :white) }

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
      let(:black_pawn) { instance_double(ChessPawn, color: :black) }

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
    let(:white_pawn) { instance_double(ChessPawn, color: :white, position: [6, 0])}

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

  describe '#is_player_check?' do
    let(:white_player) { instance_double(ChessPlayer, color: :white) }
    let(:white_king) { instance_double(ChessKing, color: :white) }

    context 'when the player is check' do

      before do
        allow(game).to receive(:select_player_king).with(white_player).and_return(white_king)
        allow(board).to receive(:is_check?).with(white_king).and_return(true)
      end

      it 'returns true' do
        result = game.is_player_check?(white_player)
        expect(result).to be(true)
      end
    end

    context 'when the player is not check' do

      before do
        allow(game).to receive(:select_player_king).with(white_player).and_return(white_king)
        allow(board).to receive(:is_check?).with(white_king).and_return(false)
      end

      it 'returns false' do
        result = game.is_player_check?(white_player)
        expect(result).to be(false)
      end
    end
  end

  describe '#select_player_king' do
    let(:white_player) { instance_double(ChessPlayer, color: :white) }
    let(:black_player) { instance_double(ChessPlayer, color: :black) }

    let(:white_king) { instance_double(ChessKing, color: :white) }
    let(:black_king) { instance_double(ChessKing, color: :black) }

    before do
      allow(board).to receive(:pieces).and_return([white_king, black_king])
      allow(white_king).to receive(:is_a?).with(ChessKing).and_return(true)
      allow(black_king).to receive(:is_a?).with(ChessKing).and_return(true)

    end

    context 'when the player is white' do
      it 'returns the whiteking' do
        result = game.select_player_king(white_player)
        expect(result).to eq(white_king)
      end
    end

    context 'when player is black' do
      it 'returns the black_king' do
        result = game.select_player_king(black_king)
        expect(result).to eq(black_king)
      end
    end
  end
end
