wf = require 'windfield'

-- The finished player object
cat = {
  x = 16,
  y = 16,
  -- The first set of values are for our rudimentary physics system
  xVelocity = 0, -- current velocity on x, y axes
  yVelocity = 0,
  acc = 100, -- the acceleration of our player
  maxSpeed = 600, -- the top speed
  friction = 20, -- slow our player down - we could toggle this situationally to create icy or slick platforms
  gravity = 80, -- we will accelerate towards the bottom

  -- These are values applying specifically to jumping
  isJumping = false, -- are we in the process of jumping?
  isGrounded = false, -- are we on the ground?
  hasReachedMax = false, -- is this as high as we can go?
  jumpAcc = 500, -- how fast do we accelerate towards the top
  jumpMaxSpeed = 9.5, -- our speed limit while jumping

  -- Here are some incidental storage areas
  img = love.graphics.newImage('assets/cat.png') -- store the sprite we'll be drawing
}

-- Loading
function love.load(arg)
  world = wf.newWorld(0, 0, true)
  world:newRectangleCollider(200, 300, 20, 20)
end

-- Updating
function love.update(dt)
  world:update(dt)
end

-- Drawing
function love.draw()
  world:draw()
	love.graphics.draw(cat.img, cat.x, cat.y)
end
