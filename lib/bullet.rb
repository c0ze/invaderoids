# These are bullets shot by the player's ship
class Bullet < Engine::Sprite
  Speed = 40
  BoomOffset = 10
  
  # Constructor
  def initialize(x, y, angle)
    super()
    
    @image = Engine::Game.images["laser"]
    @x = x
    @y = y
    @z = ZOrder::Bullet
    @radius = 8
    @angle = angle
    @vel_x = Speed * Gosu::offset_x(@angle, 0.5)
    @vel_y = Speed * Gosu::offset_y(@angle, 0.5)
  end
  
  # Updates the bullet
  def update
    @x += @vel_x
    @y += @vel_y
        
    collide = false    
    # collisions against aliens
    Engine::Game.sprites[Alien].each do |alien|
      if collision?(alien)
        collide = true
        alien.destroy! # kills the alien
        Engine::Game.game_state.increase_score!(50) # award the player with some points
      end
    end
    
    # destroy the bullet when it reaches the top of the screen or collides with an enemy
    kill! if !@y.between?(0, Engine::Game::ScreenHeight) or !@x.between?(0, Engine::Game::ScreenWidth) or collide
  end
end
