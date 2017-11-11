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
  maxSpeed = 500,

  hasCoughtItem = false,
  isDoubleJumping = false,
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
	world:addCollisionClass('Player')

  -- Setup collision logic
  world:addCollisionClass('Ground')
  world:addCollisionClass('Wall')
  world:addCollisionClass('Platform')
  world:addCollisionClass('DynObject')
  world:addCollisionClass('Cat')

  tbl = world:newRectangleCollider(200, 500, 400, 20)
  tbl:setType('static')
  tbl:setCollisionClass('Platform')

  cat.body = world:newRectangleCollider(cat.x, cat.y, 20, 40)
  cat.body:setType('dynamic')
	cat.body:setRestitution(0.0)
  cat.body:setCollisionClass('Cat')
  cat.body:setFixedRotation(true)

  cat.body:setPreSolve(function(col1, col2, contact)
      if col1.collision_class == 'Cat' and col2.collision_class == 'Platform' then
        local cx, cy = col1:getPosition()
        local cw, ch = 20, 40
        local tx, ty = col2:getPosition()
        local tw, th = 400, 20
        if cy + ch/2 > ty - th/2 then
          print('below')
          contact:setEnabled(false)
        else
          contact:setEnabled(true)
          print('above')
        end
      end
  end)

  ground = world:newRectangleCollider(0, love.graphics.getHeight() - 20, love.graphics.getWidth(), 20)
  ground:setCollisionClass('Ground')
  ground:setType('static')
  cat.body:setSleepingAllowed(false)
end

-- Updating
function love.update(dt)
  cat.body:setX(cat.body:getX() + cat.xVelocity)

  world:update(dt)

 	if cat.body:enter("Ground") or cat.body:enter("Platform") then
 		cat.isJumping = false
 		cat.isDoubleJumping = false
 	end

  -- Apply Friction
  cat.xVelocity = cat.xVelocity * (1 - math.min(dt * cat.friction, 1))
  cat.yVelocity = cat.yVelocity * (1 - math.min(dt * cat.friction, 1))

  if love.keyboard.isDown("left") then
    keydown("left", dt)
	elseif love.keyboard.isDown("right") then
		keydown("right", dt)
	end
end

-- Drawing
function love.draw()
  world:draw()

	love.graphics.draw(cat.img, cat.x, cat.y)
end

-- Keys pressed
function love.keypressed(key)
	if key == "up" then
		jump()
	elseif key == "space" then
		catchitem()
	end
end

function keydown(key, dt)
  if key == "left" and cat.xVelocity > -cat.maxSpeed then
		cat.xVelocity = cat.xVelocity - cat.acc * dt
	elseif key == "right" and cat.xVelocity < cat.maxSpeed then
		cat.xVelocity = cat.xVelocity + cat.acc * dt
	end
end

function jump()
	if cat.isJumping == true then
		if cat.isDoubleJumping == false then
			cat.body:applyLinearImpulse(0, -500)
			cat.isDoubleJumping = true
		end
	else
		cat.body:applyLinearImpulse(0, -500)
		cat.isJumping = true
	end
end

function catchitem()
	if cat.hasCoughtItem == false then


		cat.hasCoughtItem = true
	end
end
