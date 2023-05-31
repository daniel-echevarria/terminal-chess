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
        result = game.valid_pick?(player_1, pick)
        expect(result).to be(true)
      end
    end

    context 'when player is white and picks a black piece' do
      let(:blackpawn) { instance_double(ChessPawn, color: 'black') }

      before do
        pick = 'a7'
        allow(game).to receive(:translate_chess_to_array).with(pick).and_return([1, 0])
        allow(game).to receive(:select_piece).with([1, 0]).and_return(blackpawn)
        allow(blackpawn).to receive(:color).and_return('black')
      end

      it 'returns false' do
        pick = 'a7'
        result = game.valid_pick?(player_1, pick)
        expect(result).to be(false)
      end
    end
  end

  describe '#move_piece_input' do
    let(:whitepawn) { instance_double(ChessPawn, color: 'white', position: [6, 0])}

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
        game.move_piece_input(whitepawn)
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
        game.move_piece_input(whitepawn)
      end
    end
  end

  describe '#valid_move?' do
    let(:whitepawn) { instance_double(ChessPawn, position: [6, 0])}
    before do
      allow(game).to receive(:get_possible_moves).with(whitepawn, board).and_return([[5, 0], [4, 0]])
    end

    context 'when the move is valid' do
      it 'returns true' do
        to_position = [5, 0]
        result = game.valid_move?(whitepawn, to_position)
        expect(result).to be(true)
      end
    end

    context 'when the move is not valid' do
      it 'returns false' do
        to_position = [3, 3]
        result = game.valid_move?(whitepawn, to_position)
        expect(result).to be(false)
      end
    end
  end
end
