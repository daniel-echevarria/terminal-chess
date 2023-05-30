require_relative '../lib/chess_game.rb'
require_relative '../lib/chess_game_player.rb'
require_relative '../lib/chess_game_board.rb'
require_relative '../lib/chess_game_pawn.rb'

describe ChessGame do
  context 'when player is white'
  let(:board) { double('board') }
  let(:player_1) { instance_double(ChessPlayer, color: 'white') }
  let(:player_2) { instance_double(ChessPlayer, color: 'black') }
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
      let(:whitepawn) { instance_double(ChessPawn, color: 'white') }

      before do
        pick = 'a2'
        allow(game).to receive(:translate_chess_to_array).with(pick).and_return([6, 0])
        allow(game).to receive(:select_piece).with([6, 0]).and_return(whitepawn)
        allow(whitepawn).to receive(:color).and_return('white')
      end

      it 'returns true' do
        pick = 'a2'
        player = player_1
        result = game.valid_pick?(player_1, pick)
        expect(result).to be(true)
      end
    end
  end
end
