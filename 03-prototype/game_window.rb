# Clase que gestiona los distintos estados del juego.
class GameWindow < Gosu::Window
  SCREEN_WIDTH = 800
  SCREEN_HEIGHT = 600
  attr_accessor :state

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
  end

  def update
    @state.update
  end

  def draw
    @state.draw
  end

  def needs_redraw?
    @state.needs_redraw?
  end

  def button_down(id)
    @state.button_down(id)
  end

end
