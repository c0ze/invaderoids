# These ones are the cute bad guys
class Alien < Engine::Sprite
  MaxSpeedX = 4
  MaxSpeedY = 8
  MinSpeedY = 3
  AnimTime = 500
  BoomOffset = 10

  attr_reader :x, :y

  # Constructor
  def initialize
    super

    @image = Engine::Game.images["alien"]
    @z = ZOrder::Alien
    @radius = 20

    @x = rand * 640
    @y = rand * 480
  end

  # Updates the alien
  def update
    @x += rand(11) - 5
    @y += rand(11) - 5


    if @x < 0 || @x > 640
      @x = 320
    end

    if @y < 0 || @y > 480
      @y = 240
    end

    # animation
    @index = Gosu::milliseconds / AnimTime % @image.size
  end

  # Kills the alien with an explosion
  def destroy!
    (rand(3) + 5).times { Explosion.new(@x + rand(BoomOffset * 2) - BoomOffset, @y + rand(BoomOffset * 2) - BoomOffset) }
    kill!
  end

end
