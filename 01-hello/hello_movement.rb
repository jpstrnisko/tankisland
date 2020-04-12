require 'gosu'

# Crea una ventana con un titulo y un texto flotante con la posicion y numero de redibujado
# el cual se mueve con las flechitas.

class GameWindow < Gosu::Window
  def initialize(width = 320, height = 240, fullscreen = false)
    super
    self.caption = 'Hello movement!'

    @x = @y = 10
    @draws = 0
    @buttons_down = 0
  end

  def update
    @x -= 1 if button_down?(Gosu::KB_LEFT)
    @x += 1 if button_down?(Gosu::KB_RIGHT)
    @y -= 1 if button_down?(Gosu::KB_UP)
    @y += 1 if button_down?(Gosu::KB_DOWN)
  end

  def button_down(id)
    close if id == Gosu::KB_ESCAPE
    @buttons_down +=1
  end

  def button_up(id)
    @buttons_down -= 1
  end

  # Para no utilizar procesamiento sin que haya cambios verifica si hubo cambios.
  def needs_redraw?
    @draws == 0 || @buttons_down > 0
  end

  def draw
    @draws += 1
    @message = Gosu::Image.from_text(info, 30)
    @message.draw(@x, @y, 0)
  end

  private

  def info
    "[x:#{@x};y:#{@y};draws:#{@draws}]"
  end
end

window = GameWindow.new
window.show
