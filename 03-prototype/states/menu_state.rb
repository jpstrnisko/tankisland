require 'singleton'

class MenuState < GameState

  TITLE_SIZE = 100
  MESSAGE_SIZE = 10
  CONTINUE_SIZE = 30
  include Singleton
  attr_accessor :play_state

  def initialize
    @message = Gosu::Image.from_text("Tanks Prototype", TITLE_SIZE)
  end

  def enter
    music.play(true)
    music.volume = 1
  end

  def leave
    music.volume = 0
    music.stop
  end

  def music
    @@music ||= Gosu::Song.new(Game.media_path('menu_music.ogg'))
  end

  def draw
    @message.draw($window.width / 2 - @message.width / 2, $window.height / 2 - @message.height / 2, MESSAGE_SIZE)
    @info.draw($window.width / 2 - @info.width / 2, $window.height / 2 - @info.height / 2 + 200, MESSAGE_SIZE)
  end

  def update
    continue_text = @play_state ? "C = Continue, " : ""
    @info = Gosu::Image.from_text("Q = Quit, #{continue_text}N = New Game", CONTINUE_SIZE)
  end

  def button_down(id)
    $window.close if id == Gosu::KB_Q
    if id == Gosu::KB_C &&
      GameState.switch(@play_state)
    end
    if id == Gosu::KB_N
      @play_state = PlayState.new
      GameState.switch(@play_state)
    end
  end
end