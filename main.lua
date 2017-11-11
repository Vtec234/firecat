function love.load()
  x, y = 500, 20
end

function love.update(dt)
  if y > 0 then
    y = y + 5 * dt
  end
end

function love.draw()
  love.graphics.circle("fill", x, y, 4)
end
