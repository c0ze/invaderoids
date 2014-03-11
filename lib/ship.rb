# This is the player's ship. It can shoot bullets and should avoid
# enemy aliens to survive.
class Ship < Engine::Sprite
  Speed = 6
  BoomOffset = 10
  
  attr_reader :energy
  
  # Constructor
  def initialize
    super
    
    @x = Engine::Game::ScreenWidth / 2
    @y = Engine::Game::ScreenHeight / 2
    @z = ZOrder::Ship
    @image = Engine::Game.images["captain"]
    @fire_sound = Engine::Game.sounds["laser"]
    @explosion_sound = Engine::Game.sounds["explosion"]
    
    @vel_x = @vel_y = @angle = 0.0

    @radius = 30
  end
 
  def warp(x, y)
    @x, @y = x, y
  end
  
  def turn_left
    @angle -= 4.5
  end
  
  def turn_right
    @angle += 4.5
  end
  
  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end

  
  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 640
    @y %= 480
    
    @vel_x *= 0.95
    @vel_y *= 0.95
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

 
  # Updates the ship
  def update
    # collision against aliens
    Engine::Game.sprites[Alien].each do |alien|
      if collision?(alien)
        @explosion_sound.play
        alien.destroy!
        Engine::Game.game_state.decrease_energy
      end
    end
  end
  

  def fire bullet
    Bullet.new self, bullet, (@x + @image.width/2), (@y + @image.height/2), @angle
  end
  
  # Shoots a bullet
  def shoot
    @fire_sound.play
    Bullet.new(@x, @y, @angle)
  end
  
  # Kills the ship with an explosion
  def destroy!
    @explosion_sound.play
    (rand(3) + 5).times { Explosion.new(@x + rand(BoomOffset * 2) - BoomOffset, @y + rand(BoomOffset * 2) - BoomOffset) }
    kill!
  end
end
