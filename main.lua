-- variables
local waves

-- objects
local number = {}
local circle = {}

function love.load(arg)
  font = love.graphics.newFont('fipps.otf', 32)
  font:setFilter('nearest')

  local ww, wh = love.graphics.getDimensions()
  local file = love.filesystem.newFile('score', 'r')
  local score
  if file then
    score = file:read()

    file:close()
  end

  local radius = (ww < wh) and (ww * .3) or (wh * .3)

  circle.x = ww/2
  circle.y = wh/2
  circle.radius = radius

  number.value = tonumber(score) or 0
  number.x = ww/2
  number.y = wh/2
  number.rotation = 0
  number.scale = 2

  waves = {}
end

function love.update(dt)
  number.rotation = (number.rotation + dt) % (math.pi*2)

  for i, e in ipairs(waves) do
    waves[i] = e - dt * 200

    if e <= 0 then
      table.remove(waves, i)
    end
  end
end

function love.mousepressed(mx, my, bt)
  if (mx - circle.x)^2 + (my - circle.y)^2 <= circle.radius^2 then
    number.value = number.value + 1
    table.insert(waves, circle.radius)
  end
end

function love.keypressed(key)
  if key == 'escape' then love.event.quit() end
end

function love.draw()
  local ww, wh = love.graphics.getDimensions()

  local rad = ww*.3

  love.graphics.circle('line', circle.x, circle.y, circle.radius)
  -- love.graphics.circle('line', circle.x, circle.y, font:getHeight())

  for i, e in ipairs(waves) do
    love.graphics.circle('line', circle.x, circle.y, e)
  end

  love.graphics.setColor(1,1,1)
  love.graphics.print(
    number.value,
    font,
    number.x,
    number.y,
    number.rotation,
    number.scale,
    number.scale,
    font:getWidth(number.value)/2,
    font:getHeight()/2
  )
end

function love.visible(visible)
  if not visible then
    local file = love.filesystem.newFile('score', 'w')
    file:write(number.value)
    file:close()
  end
end

function love.quit()
  local file = love.filesystem.newFile('score', 'w')
  file:write(number.value)
  file:close()
end
