# -*- coding: utf-8 -*-
require 'singleton'
require 'pry'

module Engine
  class Game < Gosu::Window
    include Singleton

    ScreenWidth = 550
    ScreenHeight = 600
    FadingTime = 1000

    attr_accessor :level

    # Constructor. Setups the video mode and creates a window (60 fps)
    def initialize
      super(ScreenWidth, ScreenHeight, false)
      self.caption = "Invaderoids"
      @@sprite_collection = SpriteCollection.new
      @@images = Hash.new
      @@sounds = Hash.new
      @@fonts = Hash.new
      load_images
      load_sounds
      load_fonts

      @@level = 1

      @@img_fade = @@images["black"]
      @@fading_off = false
      @@fading_on = false
      @@end_fade = 0
      @@start_fade = 0

      @@change_game_state = nil
      @@game_state = MenuState.new
    end

    def Game.level
      @@level
    end

    # Returns a hash map with the images collection
    def Game.images
      @@images
    end

    def Game.sounds
      @@sounds
    end

    # Returns a hash map with the fonts collection
    def Game.fonts
      @@fonts
    end

    # Returns a hash map with the sprite lists
    def Game.sprites
      @@sprite_collection.sprites
    end

    # Returns the sprite collection
    def Game.sprite_collection
      @@sprite_collection
    end

    # Returns the current game state
    def Game.game_state
      @@game_state
    end

    # Changes to another game state
    def Game.game_state=(st)
#      binding.pry
      if ["Engine::LevelBeginState", "Engine::PlayState"].include? st.inspect
        @@change_game_state = st.new @@level
      else
        @@change_game_state = st.new
      end
      Game.fade_off(FadingTime)
    end

    def Game.level_progress
      @@level += 1
      Game.game_state = LevelBeginState
    end

    # Quits game
    def Game.quit
      self.instance.close
    end

    # Starts a fade off transition
    def Game.fade_off(time)
      return if Game.fading?
      @@start_fade = Gosu::milliseconds
      @@end_fade = @@start_fade + time
      @@fading_off = true
    end

    # Starts a fade on transition
    def Game.fade_on(time)
      return if Game.fading?
      @@start_fade = Gosu::milliseconds
      @@end_fade = @@start_fade + time
      @@fading_on = true
    end

    # Returns whether there is a fade running or not
    def Game.fading?
      @@fading_off or @@fading_on
    end

    # Ends fade transitions
    def Game.end_fade!
      @@fading_off = false
      @@fading_on = false
    end

    # Updates the game logic. Gets called automatically by Gosu each frame
    def update
      @@game_state.update unless Game.fading?

      # update fading
      Game.end_fade! if Gosu::milliseconds >= @@end_fade and Game.fading?

      #update changing between game states
      if @@change_game_state and not Game.fading?
        @@game_state = @@change_game_state
        @@change_game_state = nil
        Game.fade_on(FadingTime)
      end
    end

    # Draws the game entities on the screen. Gets called automatically by Gosu each frame
    def draw
      @@game_state.draw

      if Game.fading?
        delta = (Gosu::milliseconds - @@start_fade).to_f / (@@end_fade - @@start_fade)
        alpha = @@fading_off ? delta : 1 - delta
        @@img_fade.draw(0, 0, ZOrder::Fade, 1, 1, Gosu::Color.new((alpha * 0xff).to_i, 0xff, 0xff, 0xff))
      end
    end

    # Gets called automatically by Gosu when a button is released
    def button_up(id)
      @@game_state.button_up(id)
    end

    # Gets called automatically by Gosu when a button is pressed
    def button_down(id)
      @@game_state.button_down(id)
    end

    # Loads all the images and stores them into the images hash map
    def load_images
      @@images["black"] = Gosu::Image.new(self, "#{GFX_DIR}/black.png", true)
      @@images["background"] = Gosu::Image.new(self, "#{GFX_DIR}/background.png", true)
      @@images["captain"] = Gosu::Image.new(self, "#{GFX_DIR}/captain.png", false)
      @@images["laser"] = Gosu::Image.new(self, "#{GFX_DIR}/laser.png", false)
      @@images["alien"] = Gosu::Image.load_tiles(self, "#{GFX_DIR}/alien.png", 48, 42, false)
      @@images["energy full"] = Gosu::Image.new(self, "#{GFX_DIR}/energy_full.png", false)
      @@images["energy low"] = Gosu::Image.new(self, "#{GFX_DIR}/energy_low.png", false)
      @@images["hud"] = Gosu::Image.new(self, "#{GFX_DIR}/hud.png", false)
      @@images["boom"] = Gosu::Image.new(self, "#{GFX_DIR}/boom.png", false)
      @@images["gameover"] = Gosu::Image.new(self, "#{GFX_DIR}/game_over.png", false)
      @@images["logo"] = Gosu::Image.new(self, "#{GFX_DIR}/game_logo.png", false)
      @@images["credits"] = Gosu::Image.new(self, "#{GFX_DIR}/credits.png", false)
    end

    # Loads all the images and stores them into the images hash map
    def load_sounds
      @@sounds["laser"] = Gosu::Sample.new(self, "#{AUDIO_DIR}/laser.ogg")
      @@sounds["explosion"] = Gosu::Sample.new(self, "#{AUDIO_DIR}/explosion.ogg")
    end

    # Loads all fonts needed and stores them into the fonts hash map
    def load_fonts
      @@fonts["menu"] = Gosu::Font.new(self, "Courier", 40)
      @@fonts["score"] = Gosu::Font.new(self, "Courier", 50)
      @@fonts["small"] = Gosu::Font.new(self, "Courier", 30)
      @@fonts["logo"] = Gosu::Font.new(self, ASSETS_DIR + "star_hollow.ttf", 30)
    end

  end

end
