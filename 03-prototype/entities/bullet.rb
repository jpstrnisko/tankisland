class Bullet
  COLOR = Gosu::Color::BLACK
  MAX_DISTANCE = 300
  START_DISTANCE = 20

  def initialize(source_x, source_y, target_x, target_y)
    @x, @y = source_x, source_y
    @target_x, @target_y = target_x, target_y
    @x, @y = point_at_distance(START_DISTANCE)
    if trajectory_length > MAX_DISTANCE
      @target_x, @target_y = point_at_distance(MAX_DISTANCE)
    end
    sound.play
  end

  def draw
    if arrived?
      @explosion ||= Explosion.new(@x, @y)
      @explosion.draw
    else
      $window.draw_quad(@x - 2, @y - 2, COLOR, @x + 2, @y - 2, COLOR, @x - 2, @y + 2, COLOR, @x + 2, @y + 2, COLOR, 1)
    end
  end

  def update
    fly_distance = (Gosu.milliseconds - @fired_at) * 0.0001 * @speed
    @x, @y = point_at_distance(fly_distance)
    @explosion && @explosion.update
  end

  def arrived?
    @x == @target_x && @y == @target_y
  end

  def done?
    exploaded?
  end

  def exploaded?
    @explosion && @explosion.done?
  end

  def fire(speed)
    @speed = speed
    @fired_at = Gosu.milliseconds
    self
  end

  private

  def sound
    @@sound ||= Gosu::Sample.new(Game.media_path('fire.ogg'))
  end

  def trajectory_length
    distance_x = @target_x - @x
    distance_y = @target_y - @y
    Math.sqrt(distance_x * distance_x + distance_y * distance_y)
  end

  # Devuelve el punto maximo de distancia que esta en la direccion en la que se disparo.
  def point_at_distance(distance)
    return [@target_x, @target_y] if distance > trajectory_length
    distance_factor = distance.to_f / trajectory_length
    point_x = @x + (@target_x - @x) * distance_factor
    point_y = @y + (@target_y - @y) * distance_factor
    [point_x, point_y]
  end
end
