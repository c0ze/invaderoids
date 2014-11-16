# encoding: utf-8

module Engine
  # This game state is the screen which shows up level
  class LevelBeginState
    # Constructor
    def initialize level
      @img_background = Game.images["background"]
      @img_gosu = Game.images["gosu"]

      @font_small = Game.fonts["small"]
      @font_credits = Game.fonts["menu"]

      @logo_font = Game::fonts["logo"]
      @level = level
    end

    # Draws the level screen
    def draw
      @img_background.draw(0, 0, 0)

      color = 0xfff4cc00
      @logo_font.draw_rel("Level #{@level}", Game::ScreenWidth / 2, 120, ZOrder::Hud, 0.5, 0.5, 2, 2, color)

    end

    # Gets called when the player releases a button
    def button_up(id)
      Game.begin_game if id == Gosu::KbEscape or id == Gosu::KbReturn or Gosu::KbSpace
    end
  end
end
