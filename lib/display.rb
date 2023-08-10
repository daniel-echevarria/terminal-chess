
require_relative 'chess_array_translator.rb'

class ChessDisplay
  include ChessArrayTranslator

  COLORS = {
    red: "\e[31m",
    green: "\e[32m",
    yellow: "\e[33m",
    blue: "\e[34m",
    magenta: "\e[35m",
    cyan: "\e[36m"
  }

  def display_message_in_color(message, color)
    puts "#{COLORS[color]} #{message} \e[0m"
  end

  def select_piece_message(player)
    message = "#{player.name} select the piece you would like to move by typing it\'s position"
    display_message_in_color(message, :yellow)
  end

  def move_piece_message(piece)
    chess_position = translate_array_to_chess(piece.position)
    confirm_selection_message = "You just selected the #{piece.specie} on #{chess_position}"
    display_message_in_color(confirm_selection_message, :green)
    message = "Type the square you want to move the #{piece.specie} to"
    display_message_in_color(message, :yellow)
  end

  def check_message(player)
    message = "#{player.name} you are in check!"
    display_message_in_color(message, :magenta)
  end

  def check_mate_message(player)
    message = "Game is over, #{player.name} you are check_mate!"
    display_message_in_color(message, :red)
  end

  def promotion_message(player)
    message = "Which piece do you want to promote the pawn to #{player}?"
    display_message_in_color(message, :yellow)
  end

  def wrong_promotion
    message = <<~HEREDOC
      Please input a valid piece to promote the pawn to, the options are:
      queen
      bishop
      knight
      rook
    HEREDOC
    display_message_in_color(message, :red)
  end

  def draw_message
   message = 'Congratulations girls the game is draw and you both won! (or none of you did depending how you want to look at it)'
   display_message_in_color(message, :green)
  end
end
