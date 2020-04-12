require 'gosu'
require 'gosu_tiled'

# Muestra el render de un tiled map con la funcionalidad de moverse alrededor.

class GameWindow < Gosu::Window
  # El JSON del mapa debe tener los JSON de sus texturas dentro, no referenciados.
  MAP_FILE = File.join(File.dirname(__FILE__ ), '../media/tiled_map.json')
  SPEED = 5
  MAP_WIDTH = 640
  MAP_HEIGHT = 640

  def initialize
    super(MAP_WIDTH, MAP_HEIGHT, false)
    @map = Gosu::Tiled.load_json(self, MAP_FILE)
    @x = @y = 0
    @first_render = true
    @buttons_down = 0
  end

  def button_down(id)
    close if id == Gosu::KB_ESCAPE
    @buttons_down += 1
  end

  def button_up(id)
    @buttons_down -= 1
  end

  def update
    @x -= SPEED if button_down?(Gosu::KB_LEFT) & (@x > 0)
    @x += SPEED if button_down?(Gosu::KB_RIGHT)& ( @x < MAP_WIDTH)
    @y -= SPEED if button_down?(Gosu::KB_UP) & (@y > 0)
    @y += SPEED if button_down?(Gosu::KB_DOWN) & (@y < MAP_HEIGHT)
    self.caption = "#{Gosu.fps} FPS. Use arrow keys to pan"
  end

  def draw
    @first_render = false
    @map.draw(@x, @y)
  end

  def needs_redraw?
    [Gosu::KB_LEFT, Gosu::KB_RIGHT, Gosu::KB_UP, Gosu::KB_UP].each do |key|
      return true if button_down(key)
      return true if button_down(key)
    end
    @first_render
  end
end

window = GameWindow.new
window.show