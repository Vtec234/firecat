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

	-- These are values applying specifically to jumping
	isJumping = false, -- are we in the process of jumping?
	isDoubleJumping = false,
	isGrounded = false, -- are we on the ground?
	hasReachedMax = false, -- is this as high as we can go?

	-- Here are some incidental storage areas
	img = love.graphics.newImage("assets/cat.png"), -- store the sprite we'll be drawing
	body = nil
}

-- Loading
function love.load(arg)
	world = wf.newWorld(0, 0, true)
	world:setGravity(0, 512)
	world:addCollisionClass('Player')

	cat.body = world:newRectangleCollider(cat.x, cat.y, 20, 40)
	cat.body:setRestitution(0.0)
	cat.body:setType("dynamic")
  	cat.body:setCollisionClass('Player')

  	ground = world:newRectangleCollider(0, love.graphics.getHeight() - 20, love.graphics.getWidth(), 20)
  	ground:setType('static')
end

-- Updating
function love.update(dt)
  	world:update(dt)

	x, y = cat.body:getPosition()
	cat.body:setPosition(x + cat.xVelocity, y)

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
	    cat.body:applyLinearImpulse(0, -500)
	end
end

function keydown(key, dt)
  	if key == "left" and cat.xVelocity > -cat.maxSpeed then
		cat.xVelocity = cat.xVelocity - cat.acc * dt
	elseif key == "right" and cat.xVelocity < cat.maxSpeed then
		cat.xVelocity = cat.xVelocity + cat.acc * dt
	end
end