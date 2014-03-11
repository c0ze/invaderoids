# encoding: utf-8

module Engine
  # This game state is the Credits screen
  class CreditsState < GameState
    # Constructor
    def initialize
      @img_background = Game.images["background"]
      @img_credits = Game.images["credits"]
      @img_gosu = Game.images["gosu"]

      @font_small = Game.fonts["small"]
      @font_credits = Game.fonts["menu"]

      @scroll_text = ScrollingText.new "Music Credits  -  Menu Screen : Strobe & Rebb – Melonia, http://www.milkytracker.org/?download  -  In game : Reed - Civilian, http://www.cvgm.net/demovibes/song/4224/  -  Gameover : Tim Wright - Shadow of the Beast II, http://www.exotica.org.uk/wiki/Shadow_of_the_Beast_II     -    Sound samples : http://soundbible.com/free-sound-effects-1.html", @font_small, 420
    end

    # Draws the credits screen
    def draw
      @img_background.draw(0, 0, 0)
      @img_credits.draw_rot(Game::ScreenWidth / 2, 120, ZOrder::Hud, 0)

      @font_small.draw_rel("Made by", Game::ScreenWidth / 2, 200, ZOrder::Hud, 0.5, 0.5)
      @font_credits.draw_rel("Arda Karaduman", Game::ScreenWidth / 2, 300, ZOrder::Hud, 0.5, 0.5)
      @font_small.draw_rel("blog.coze.org", Game::ScreenWidth / 2, 340, ZOrder::Hud, 0.5, 0.5, 1, 1, 0xfff4cc00)

      @scroll_text.scroll
      @scroll_text.draw

      @font_small.draw_rel("Sample game for Gosu", Game::ScreenWidth / 2, 500, ZOrder::Hud, 0.5, 0.5)
      @font_small.draw_rel("www.libgosu.org", Game::ScreenWidth / 2, 530, ZOrder::Hud, 0.5, 0.5, 1, 1, 0xfff4cc00)
    end

    # Gets called when the player releases a button
    def button_up(id)
      # go back to the main menu
      Game.game_state = MenuState if id == Gosu::KbEscape or id == Gosu::KbReturn or Gosu::KbSpace
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
      if @x < -2300
        @x = Game::ScreenWidth*5
      end
      @x -= 1
    end

    def draw
      @font.draw_rel(@text,  @x, @y, ZOrder::Hud, 0.5, 0.5)
    end
  end

end
