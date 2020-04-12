class Camera
  attr_accessor :x, :y, :zoom

  # Target es el objeto al cual sigue la camara.
  def initialize(target)
    @target = target
    @x, @y = target.x, target.y
    @zoom = 1
  end

  # Devuelve si el objeto en la posicion (x,y) esta dentro del rango de la camara.
  def can_view?(x, y, obj)
    x0, x1, y0, y1 = viewport
    (x0 - obj.width..x1).include?(x) && (y0 - obj.height..y1).include?(y)
  end

  # Convierte la posicion del mouse en la pantalla a su posicion relativa en el mapa.
  def mouse_coords
    x, y = target_delta_on_screen
    mouse_x_on_map = @target.x + (x + $window.mouse_x - ($window.width / 2)) / @zoom
    mouse_y_on_map = @target.y + (x + $window.mouse_y - ($window.height / 2)) / @zoom
    return [mouse_x_on_map, mouse_y_on_map]
  end

  # Revisa la distancia entre la posicion de la camara (x, y) y la posicion del target. Ajusta para quedar apuntando.
  # Cuando se acelera el target la camara se aleja un poco.
  def update
    @x += @target.speed if @x < @target.x - $window.width / 4
    @x -= @target.speed if @x > @target.x + $window.width / 4
    @y += @target.speed if @y < @target.y - $window.height / 4
    @y -= @target.speed if @y > @target.y + $window.height / 4

    zoom_delta = @zoom > 0 ? 0.01 : 1.0

    if $window.button_down?(Gosu::KB_UP)
      @zoom -= zoom_delta unless @zoom < 0.7
    elsif $window.button_down?(Gosu::KB_DOWN)
      @zoom += zoom_delta unless @zoom > 10
    else
      target_zoom = @target.speed > 1.1 ? 0.85 : 1.0
      if @zoom <= (target_zoom - 0.01)
        @zoom += zoom_delta / 3
      elsif @zoom > (target_zoom + 0.01)
        @zoom -= zoom_delta / 3
      end
    end
  end

  def to_s
    "FPS: #{Gosu.fps}. " << "#{@x}::#{@y} @ #{'%.2f' % @zoom}. " << 'WASD to move, arrows to zoom.'
  end

  def target_delta_on_screen
    [(@x - @target.x) * @zoom, (@y - @target.y) * @zoom]
  end

  def draw_crosshair
    x = $window.mouse_x
    y = $window.mouse_y
    $window.draw_line(x - 10 * @zoom, y, Gosu::Color::RED, x - 1 * @zoom, y, Gosu::Color::RED)
    $window.draw_line(x + 1 * @zoom, y, Gosu::Color::RED, x + 10 * @zoom, y, Gosu::Color::RED)
    $window.draw_line(x, y - 10 * @zoom, Gosu::Color::RED, x, y - 1 * @zoom, Gosu::Color::RED)
    $window.draw_line(x, y + 1 * @zoom, Gosu::Color::RED, x, y + 10 * @zoom, Gosu::Color::RED)
  end

  private

  def viewport
    x0 = @x - ($window.width / 2) / @zoom
    x1 = @x + ($window.width / 2) / @zoom
    y0 = @y - ($window.height / 2) / @zoom
    y1 = @y + ($window.height / 2) / @zoom
    [x0, x1, y0, y1]
  end
end
