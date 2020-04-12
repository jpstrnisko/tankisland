class Explosion
  FRAME_DELAY = 10 #milliseconds
  TILE_SIZE = 128
  def animation
    @@animation ||= Gosu::Image.load_tiles(Game.media_path('explosion.png'), TILE_SIZE, TILE_SIZE, tileable: false)
  end

  def sound
    @@sound ||= Gosu::Sample.new(Game.media_path('explosion.ogg'))
  end

  def initialize(position_x, position_y)
    sound.play
    @x, @y = position_x, position_y
    @current_frame = 0
  end

  def update
    @current_frame += 1 if frame_expired?
  end

  def draw
    return if done?
    image = current_frame
    image.draw(@x - image.width / 2 + 3, @y - image.height / 2 - 35, 20)
  end

  def done?
    @done ||= @current_frame == animation.size
  end

  private

  def current_frame
    animation[@current_frame % animation.size]
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
