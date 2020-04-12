require 'gosu'

# Crea una ventana simple con un titulo y un texto.

class GameWindow < Gosu::Window
  SCREEN_WIDTH = 320
  SCREEN_HEIGHT = 240

  def initialize(width = SCREEN_WIDTH, height = SCREEN_HEIGHT, fullscreen = false)
    super
    self.caption ="Hello"
    @message = Gosu::Image.from_text("Hello world!", 30)
  end

  def draw
    @message.draw(10, 10, 0)
  end
end

window = GameWindow.new
window.show

