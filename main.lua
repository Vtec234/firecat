wf = require 'windfield'

-- The finished cat object
cat = {
  x = 256,
  y = 256,

  -- The first set of values are for our rudimentary physics system
  xVelocity = 0, -- current velocity on x, y axes
  yVelocity = 0,
  acc = 100, -- the acceleration of our cat
  friction = 20, -- slow our cat down - we could toggle this situationally to create icy or slick platforms

  -- These are values applying specifically to jumping
  isJumping = false, -- are we in the process of jumping?
  isGrounded = false, -- are we on the ground?
  hasReachedMax = false, -- is this as high as we can go?
  jumpAcc = 500, -- how fast do we accelerate towards the top
  jumpMaxSpeed = 9.5, -- our speed limit while jumping

  -- Here are some incidental storage areas
  img = love.graphics.newImage('assets/cat.png'), -- store the sprite we'll be drawing
  body = nil
}

-- Loading
function love.load(arg)
  world = wf.newWorld(0, 0, true)
  world:setGravity(0, 500)

  -- Setup collision logic
  world:addCollisionClass('Wall')
  world:addCollisionClass('Platform')
  world:addCollisionClass('DynObject')
  world:addCollisionClass('Cat')

  tbl = world:newRectangleCollider(200, 500, 400, 20)
  tbl:setType('static')
  tbl:setCollisionClass('Platform')

  cat.body = world:newRectangleCollider(390, 450, 20, 60)
  cat.body:setType('dynamic')
  cat.body:setCollisionClass('Cat')

  cat.body:setPreSolve(function(col1, col2, contact)
      if col1.collision_class == 'Cat' and col2.collision_class == 'Platform' then
        local cx, cy = col1:getPosition()
        local cw, ch = 400, 200
        local tx, ty = col2:getPosition()
        local tw, th = 20, 60
        if cy + ch/2 > ty - th/2 then contact:setEnabled(false) end
      end
  end)
end

-- Handle keys
function handle_keys()
  if love.keyboard.isDown('up') then
    cat.body:applyLinearImpulse(0, -1000)
  end
end

-- Updating
function love.update(dt)
  handle_keys()

  world:update(dt)

  x, y = cat.body:getPosition()
  cat.body:setPosition(x + cat.xVelocity, y)

  -- Apply Friction
  cat.xVelocity = cat.xVelocity * (1 - math.min(dt * cat.friction, 1))
  cat.yVelocity = cat.yVelocity * (1 - math.min(dt * cat.friction, 1))

	if love.keyboard.isDown("left", "a") and cat.xVelocity > -cat.maxSpeed then
		cat.xVelocity = cat.xVelocity - cat.acc * dt
	elseif love.keyboard.isDown("right", "d") and cat.xVelocity < cat.maxSpeed then
		cat.xVelocity = cat.xVelocity + cat.acc * dt
	end
end

-- Drawing
function love.draw()
  world:draw()
	love.graphics.draw(cat.img, cat.x, cat.y)
end
