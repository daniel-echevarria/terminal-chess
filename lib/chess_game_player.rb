
class ChessPlayer
  attr_reader :color
  def initialize(color, name = 'player')
    @color = color
    @name = name
  end
end
