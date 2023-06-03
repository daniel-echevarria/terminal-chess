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
        allow(game).to receive(:select_piece_at).with([6, 0]).and_return(whitepawn)
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
        allow(game).to receive(:select_piece_at).with([1, 0]).and_return(blackpawn)
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
      allow(game).to receive(:get_potential_moves).with(whitepawn).and_return([[5, 0], [4, 0]])
    end

    context 'when the move is valid' do
      it 'returns true' do
        allow(game).to receive(:translate_chess_to_array).with('a3').and_return([5, 0])
        to_position = 'a3'
        result = game.valid_move?(whitepawn, to_position)
        expect(result).to be(true)
      end
    end

    context 'when the move is not valid' do
      it 'returns false' do
        allow(game).to receive(:translate_chess_to_array).with('c3').and_return([5, 2])
        to_position = 'c3'
        result = game.valid_move?(whitepawn, to_position)
        expect(result).to be(false)
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

  describe '#select_piece_at' do
    let(:pawn_1) { instance_double(ChessPawn, position: [6, 0]) }
    let(:pawn_2) { instance_double(ChessPawn, position: [2, 3]) }
    let(:pawn_3) { instance_double(ChessPawn, position: [5, 0]) }

    before do
      game.instance_variable_set(:@pieces, [pawn_1, pawn_2, pawn_3])
    end

    context 'when there is a piece on the selected position' do
      context 'when selected position is [6, 0]' do
        it 'returns the piece on [6, 0]' do
          position = [6, 0]
          result = game.select_piece_at(position)
          expect(result).to eq(pawn_1)
        end
      end

      context 'when selected position is [2, 3]' do
        it 'returns the piece on [2, 3]' do
          position = [2, 3]
          result = game.select_piece_at(position)
          expect(result).to eq(pawn_2)
        end
      end
    end

    context 'when there is no piece on the selected position' do
      context 'when selected position is [4, 2]' do
        it 'returns nil' do
          position = [4, 2]
          result = game.select_piece_at(position)
          expect(result).to eq(nil)
        end
      end
    end
  end

  describe '#has_oponent' do
    let(:whitepawn) { instance_double(ChessPawn, color: 'white') }
    let(:blackpawn) { instance_double(ChessPawn, color: 'black') }

    context 'when the square has an opponent on it' do
      it 'returns true' do
        square = 'c7'
        position = game.translate_chess_to_array(square)
        result = game.has_oponent(whitepawn, position)
        expect(result).to eq(true)
      end
    end

    context 'when the square has no opponent on it' do
      context 'when the square is empty' do
        it 'returns false' do
          square = 'd4'
          position = game.translate_chess_to_array(square)
          result = game.has_oponent(whitepawn, position)
          expect(result).to eq(false)
        end
      end

      context 'when the square has a same color piece' do
        let(:whitepawn_2) { instance_double(ChessPawn, color: 'white', position: [4, 3]) }

        before do
          game.pieces << whitepawn_2
        end

        it 'returns false' do
          square = 'd4'
          position = game.translate_chess_to_array(square)
          result = game.has_oponent(whitepawn, position)
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
      allow(game).to receive(:select_piece_at).with(position).and_return(whitepawn_2)
    end

    context 'when there is an ally at the position' do
      it 'returns true' do
        position = [5, 0]
        result = game.has_ally(whitepawn, position)
        expect(result).to be(true)
      end
    end
  end

  describe '#special_case_pawn_moves' do
    context 'when there is an oponent in the secondary diagonal next square' do
      let(:whitepawn) { instance_double(ChessPawn, color: 'white', position: [6, 0])}
      let(:blackpawn) { instance_double(ChessPawn, color: 'black', position: [5, 1])}

      before do
        game.pieces << blackpawn
      end

      it 'returns the move' do
        result = game.special_case_pawn_moves(whitepawn)
        expect(result).to eq([[5, 1]])
      end
    end

    context 'when there is oponents on both diagonals' do
      let(:blackpawn) { instance_double(ChessPawn, color: 'black', position: [1, 4]) }
      let(:whitepawn) { instance_double(ChessPawn, color: 'white', position: [2, 3])}
      let(:whitepawn_2) { instance_double(ChessPawn, color: 'white', position: [2, 5])}

      before do
        game.pieces << whitepawn
        game.pieces << whitepawn_2
      end

      it 'returns both moves' do
        result = game.special_case_pawn_moves(blackpawn)
        expect(result).to include([2, 3],[2, 5])
      end
    end

    context 'when ther is opponents in neither diagonal' do
      let(:blackpawn) { instance_double(ChessPawn, color: 'black', position: [1, 4]) }

      it 'returns an empty []' do
        result = game.special_case_pawn_moves(blackpawn)
        expect(result).to eq([])
      end
    end

    describe '#snack_piece_at' do
      context 'when a pieces gets eaten' do
        let(:eaten_pawn) { instance_double(ChessPawn, color: 'black', position: [3, 3])}

        before do
          game.pieces << eaten_pawn
        end

        it 'removes the piece from the pieces' do
          piece_position = [3, 3]
          game.snack_piece_at(piece_position)
          expect(game.pieces).not_to include(eaten_pawn)
        end
      end
    end

    describe '#remove_invalid_moves' do
      context 'when there is an ally on one of the positions' do
        let(:moving_pawn) { instance_double(ChessPawn, color: 'white', position: [3, 3]) }
        let(:ally_pawn) { instance_double(ChessPawn, color: 'white', position: [2, 3]) }

        before do
          game.pieces << moving_pawn
          game.pieces << ally_pawn
          allow(moving_pawn).to receive(:potential_moves).and_return([2, 3])
        end

        it 'removes that position' do
          moves = game.get_potential_moves(moving_pawn)
          game.remove_invalid_moves(moving_pawn, moves)
          expect(moves).not_to include([2, 3])
        end
      end
    end
  end
end
