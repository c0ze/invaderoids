# These ones are the cute bad guys
class Heart < Engine::Sprite
  MaxSpeedX = 0
  MaxSpeedY = 0
  MinSpeedY = 0
  BoomOffset = 10

  attr_reader :x, :y

  # Constructor
  def initialize
    super

    @image = Engine::Game.images["heart"]
    @z = ZOrder::Alien
    @radius = 20

    @x = rand(640)
    @y = rand(480)
  end

  # Updates the heart
  def update
  end

  # Kills the heart with an explosion
  def destroy!
    (rand(3) + 5).times { Explosion.new(@x + rand(BoomOffset * 2) - BoomOffset, @y + rand(BoomOffset * 2) - BoomOffset) }
    kill!
  end

end
