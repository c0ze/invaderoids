# -*- coding: utf-8 -*-
require 'singleton'
require 'pry'
require 'yaml'
require 'Kii'

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
      @@assets = ::YAML.load_file(ASSETS_DIR+'manifest.yml')["assets"]
      @@sprite_collection = SpriteCollection.new
      @@images = Hash.new
      @@sounds = Hash.new
      @@fonts = Hash.new
      @@songs = Hash.new
      load_images
      load_sounds
      load_fonts
      load_songs
      initialize_kii

      @@scores = []
      @@level = 1

      @@img_fade = @@images["black"]
      @@fading_off = false
      @@fading_on = false
      @@end_fade = 0
      @@start_fade = 0

      @@change_game_state = nil
      @@game_state = MenuState.new
    end

    def initialize_kii
      @@cloud = KiiApp.new
      @@cloud.get_admin_token
    end

    def Game.submit_score(score)
      refresh_scores
      if @@scores.count < 8 or @@scores.last['score'] < score['score']
        @@cloud.buckets("high_scores").new_object(score).create
      end
    end

    def Game.refresh_scores
      scores = JSON.parse @@cloud.buckets("high_scores").get_objects
      @@scores = scores['results'].sort_by { |record| record['score'] }.reverse.first(8)
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

    def Game.songs
      @@songs
    end

    # Returns a hash map with the sprite lists
    def Game.sprites
      @@sprite_collection.sprites
    end

    # Returns the sprite collection
    def Game.sprite_collection
      @@sprite_collection
    end

    def Game.scores
      @@scores
    end

    # Returns the current game state
    def Game.game_state
      @@game_state
    end

    # Changes to another game state
    def Game.game_state=(st)
      @@change_game_state = st.new
      Game.fade_off(FadingTime)
    end

    def Game.new_game
      @@level = 1
      @@change_game_state = LevelBeginState.new @@level
      Game.fade_off(FadingTime)
    end

    def Game.begin_game(score)
      @@change_game_state = PlayState.new @@level, score
      Game.fade_off(FadingTime)
    end


    def Game.level_progress(score)
      @@level += 1
      @@change_game_state = LevelBeginState.new @@level, score
      Game.fade_off(FadingTime)
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
      # update fading
      Game.end_fade! if Gosu::milliseconds >= @@end_fade and Game.fading?

      #update changing between game states
      if @@change_game_state and not Game.fading?
        @@game_state = @@change_game_state
        @@change_game_state = nil
        Game.fade_on(FadingTime)
      end

      return unless defined? @@game_state.update
      @@game_state.update unless Game.fading?
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
      @@game_state.button_up(id) if defined? @@game_state.button_up
    end

    # Gets called automatically by Gosu when a button is pressed
    def button_down(id)
      @@game_state.button_down(id) if defined? @@game_state.button_down
    end

    # Loads all the images and stores them into the images hash map
    def load_images
      @@assets["images"].each do |asset|
        name = asset["name"]
        file_name = asset["file_name"] || "#{name}.png"
        tileable = asset["tileable"] || false

        @@images[name] = Gosu::Image.new(self, "#{GFX_DIR}/#{file_name}", tileable)
      end
      @@images["alien"] = Gosu::Image.load_tiles(self, "#{GFX_DIR}/alien.png", 48, 42, false)
    end

    # Loads all the images and stores them into the images hash map
    def load_sounds
      @@assets["sounds"].each do |asset|
        name = asset["name"]
        file_name = asset["file_name"] || "#{name}.ogg"
        @@sounds[name] = Gosu::Sample.new(self, "#{AUDIO_DIR}/#{file_name}")
      end
    end

    # Loads all fonts needed and stores them into the fonts hash map
    def load_fonts
      @@assets["fonts"].each do |asset|
        name = asset["name"]
        size = asset["size"] || 30
        file_name = asset["file_name"] ? "#{ASSETS_DIR}/#{asset["file_name"]}" : "Courier"
        @@fonts[name] = Gosu::Font.new(self, file_name, size)
      end
    end

    def load_songs
      @@assets["songs"].each do |asset|
        state = asset["state"]
        file_name = asset["file_name"]
        @@songs[state] = Gosu::Song.new("#{AUDIO_DIR}/#{file_name}")
      end
    end
  end
end
