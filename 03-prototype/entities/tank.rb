class Tank
  HALF_CIRCUNFERENCE = 180
  SHOOT_DELAY = 500
  FIRE_SPEED = 100
  MAX_SPEED = 5

  attr_accessor :x, :y, :body_angle, :gun_angle

  def initialize(map)
    @map = map
    @units = Gosu::TexturePacker.load_json(Game.media_path('ground_units.json'), :precise)
    @body = @units.frame('tank1_body.png')
    @shadow = @units.frame('tank1_body_shadow.png')
    @gun = @units.frame('tank1_dualgun.png')
    spawn_point = @map.find_spawn_point
    @x = spawn_point[0]
    @y = spawn_point[1]
    @body_angle = 0.0
    @gun_angle = 0.0
    @last_shot = 0
    sound.volume = 0.3
  end

  def sound
    @@sound ||= Gosu::Song.new(Game.media_path('tank_driving.ogg'))
  end

  def shoot(target_x, target_y)
    if Gosu.milliseconds - @last_shot > SHOOT_DELAY
      @last_shot = Gosu.milliseconds
      Bullet.new(@x, @y, target_x, target_y).fire(FIRE_SPEED)
    end
  end


  def update(camera)
    delta_x, delta_y = camera.target_delta_on_screen
    atan = Math.atan2(($window.width / 2) - delta_x - $window.mouse_x, ($window.height / 2) - delta_y - $window.mouse_y)
    @gun_angle = -atan * HALF_CIRCUNFERENCE / Math::PI
    new_x, new_y = @x, @y
    new_x -= speed if $window.button_down?(Gosu::KB_A)
    new_x += speed if $window.button_down?(Gosu::KB_D)
    new_y -= speed if $window.button_down?(Gosu::KB_W)
    new_y += speed if $window.button_down?(Gosu::KB_S)
    if @map.can_move_to?(new_x, new_y)
      @x, @y = new_x, new_y
    else
      @speed = 1.0
    end
        # Cada KB_ se refiere a una de las teclas WASD.
    @body_angle = change_angle(@body_angle, Gosu::KB_W, Gosu::KB_S, Gosu::KB_A, Gosu::KB_D)

    if moving?
      sound.play(true)
    else
      sound.pause
    end
  end

  def moving?
    any_button_down?(Gosu::KB_W, Gosu::KB_S, Gosu::KB_A, Gosu::KB_D)
  end

  def draw
    @shadow.draw_rot(@x - 1, @y - 1, 0, @body_angle)
    @body.draw_rot(@x, @y, 1, @body_angle)
    @gun.draw_rot(@x, @y, 2, @gun_angle)
  end

  def speed
    @speed ||= 1.0
    if moving?
      @speed += 0.03 if @speed < MAX_SPEED
    else
      @speed = 1.0
    end
    @speed
  end

  private

  def any_button_down?(*buttons)
    buttons.each do |b|
      return true if $window.button_down?(b)
    end
    false
  end

  def change_angle(previous_angle, up, down, right, left)
    if $window.button_down?(up)
      angle = 0.0
      angle += 45.0 if $window.button_down?(left)
      angle -= 45.0 if $window.button_down?(right)
    elsif $window.button_down?(down)
      angle = 180.0
      angle -= 45.0 if $window.button_down?(left)
      angle += 45.0 if $window.button_down?(right)
    elsif $window.button_down?(left)
      angle = 90.0
      angle += 45.0 if $window.button_down?(up)
      angle -= 45.0 if $window.button_down?(down)
    elsif $window.button_down?(right)
      angle = 270.0
      angle -= 45.0 if $window.button_down?(up)
      angle += 45.0 if $window.button_down?(down)
    end
    angle || previous_angle
  end
end
