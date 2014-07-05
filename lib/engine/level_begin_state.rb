# encoding: utf-8

module Engine
  # This game state is the screen which shows up level
  class LevelBeginState < GameState
    # Constructor
    def initialize level
      @img_background = Game.images["background"]
#      @img_credits = Game.images["credits"]
      @img_gosu = Game.images["gosu"]

      @font_small = Game.fonts["small"]
      @font_credits = Game.fonts["menu"]

      @logo_font = Game::fonts["logo"]
      @level = level
    end

    # Draws the level screen
    def draw
      @img_background.draw(0, 0, 0)
#      @img_credits.draw_rot(Game::ScreenWidth / 2, 120, ZOrder::Hud, 0)

      color = 0xfff4cc00
      @logo_font.draw_rel("Level #{@level}", Game::ScreenWidth / 2, 120, ZOrder::Hud, 0.5, 0.5, 2, 2, color)

    end

    # Gets called when the player releases a button
    def button_up(id)
      # go back to the main menu
      #binding.pry
      Game.game_state = PlayState if id == Gosu::KbEscape or id == Gosu::KbReturn or Gosu::KbSpace
    end
  end

  class ScrollingText

    def initialize text, font, y
      @text = text
      @font = font
      @y = y
      @x = Game::ScreenWidth*5
    end

    def scroll
      # some magic numbers, not nice.
      if @x < -300
        @x = Game::ScreenWidth
      end
      @x -= 1
    end

    def draw
      @font.draw_rel(@text,  @x, @y, ZOrder::Hud, 0.5, 0.5)
    end
  end

end
