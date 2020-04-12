require 'gosu'

# Encargada de apuntar los archivos a la carpeta de media.
def media_path(file)
  File.join(File.dirname(File.dirname(__FILE__ )), 'media', file)
end

class Explosion
  FRAME_DELAY = 10 #milisegundos
  SPRITE = media_path('explosion.png')

  def self.load_animation(window)
    Gosu::Image.load_tiles(SPRITE, 128, 128, tileable: false)
  end

  def initialize(animation, x, y)
    @animation = animation
    @x, @y = x, y
    @current_frame = 0
  end

  def update
    @current_frame += 1 if frame_expired?
  end

  def draw
    return if done?
    image = current_frame
    image.draw(@x - image.width / 2.0, @y - image.height / 2.0, 0)
  end

  def done?
    @done ||= @current_frame == @animation.size
  end

  private

  def current_frame
    @animation[@current_frame % @animation.size]
  end

  # Verifico si la frame actual ya supero su tiempo y paso a la siguiente.
  def frame_expired?
    now = Gosu.milliseconds
    @last_frame ||= now
    if (now - @last_frame) > FRAME_DELAY
      @last_frame = now
    end
  end
end

class GameWindow < Gosu::Window
  BACKGROUND = media_path('country_field.png')

  def initialize(width = 800, height = 600, fullscreen = false)
    super
    self.caption = ('Hello animation')
    @background = Gosu::Image.new(BACKGROUND, tileable: false)
    @animation = Explosion.load_animation(self)
    @explosions = []
  end

  # Al actualizar voy borrando de la animacion las frames que ya fueron mostradas.
  def update
    @explosions.reject!(&:done?)
    @explosions.map(&:update)
  end

  # Cuando hago click con el mouse agrego una nueva animacion de explosion.
  def button_down(id)
    close if id == Gosu::KB_ESCAPE
    if id == Gosu::MS_LEFT
      @explosions.push(Explosion.new(@animation, mouse_x, mouse_y))
    end
  end

  def needs_cursor?
    true
  end

  def needs_redraw?
    !@scene_ready || @explosions.any?
  end

  # Lo ideal es que la funcion draw sea lo mas simple posible, hacer los calculos en update.
  def draw
    @scene_ready ||= true
    @background.draw(0, 0, 0)
    @explosions.map(&:draw)
  end
end

window = GameWindow.new
window.show