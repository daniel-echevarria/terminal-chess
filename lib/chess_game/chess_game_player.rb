
class ChessPlayer
  attr_reader :color, :name
  def initialize(color, name = 'player')
    @color = color
    @name = name
  end
end
