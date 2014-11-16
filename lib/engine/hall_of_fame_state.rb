# encoding: utf-8

module Engine
  # This game state is the screen which shows high scores
  class HallOfFameState
    # Constructor
    def initialize
      @img_background = Game.images["background"]
      @img_gosu = Game.images["gosu"]

      @font_small = Game.fonts["small"]
      @font_credits = Game.fonts["menu"]

      @logo_font = Game::fonts["logo"]
      @scores = Game.scores
    end

    # Draws the level screen
    def draw
      @img_background.draw(0, 0, 0)

      color = 0xfff4cc00
      y = 120
      @scores.each do |score|
        @logo_font.draw_rel("#{score[:name]}.....#{score[:score]}", Game::ScreenWidth / 2, y, ZOrder::Hud, 0.5, 0.5, 2, 2, color)
        y += 40
      end
    end

    # Gets called when the player releases a button
    def button_up(id)
      Game.game_state = MenuState if id == Gosu::KbEscape or id == Gosu::KbReturn or Gosu::KbSpace
    end
  end
end
