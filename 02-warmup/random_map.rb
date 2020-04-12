require 'gosu'
require 'gosu_texture_packer'

# Generador de tiled maps random a partir de un tileset.

# Encargada de apuntar los archivos a la carpeta de media.
def media_path(file)
  File.join(File.dirname(File.dirname(__FILE__ )), 'media', file)
end

class GameWindow < Gosu::Window
  MAP_WIDTH = 800
  MAP_HEIGHT = 600
  TILE_SIZE = 128

  def initialize
    super(MAP_WIDTH, MAP_HEIGHT, false)
    self.caption = 'Random map'
    @tileset = Gosu::TexturePacker.load_json(media_path('ground.json'), :precise)
    @redraw = true
  end

  def button_down(id)
    close if id == Gosu::KB_ESCAPE
    @redraw = true if id == Gosu::KB_SPACE
  end

  def needs_redraw?
    @redraw
  end

  def draw
    @redraw = false
    (0..MAP_WIDTH / TILE_SIZE).each do |x|
      (0..MAP_HEIGHT / TILE_SIZE).each do |y|
        @tileset.frame(@tileset.frame_list.sample).draw(x * TILE_SIZE, y * TILE_SIZE, 0)
      end
    end
  end
end

window = GameWindow.new
window.show