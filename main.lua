local waves = {}
local number = {}
local circle = {}

function love.load(arg)
	local font = love.filesystem.getInfo('font.otf') and
		love.graphics.setNewFont('font.otf', 32) or
		love.graphics.setNewFont(32)

	local function get_score()
		local msg, _ = love.filesystem.read('score')
		return tonumber(msg)
	end

	local ww, wh = love.graphics.getDimensions()
	local radius = (ww < wh) and (ww * .3) or (wh * .3)

	-- init objects
	circle.x = ww / 2
	circle.y = wh / 2
	circle.radius = radius

	number.value = get_score() or 0
	number.x = ww / 2
	number.y = wh / 2
	number.rotation = 0
	number.scale = 2
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
	local function sq(x)
		return x * x
	end
	if sq(mx - circle.x) + sq(my - circle.y) <= sq(circle.radius) then
		number.value = number.value + 1
		table.insert(waves, circle.radius)
	end
end

function love.keypressed(key)
	if key == 'escape' then love.event.quit() end
end

function love.draw()
	love.graphics.circle('line', circle.x, circle.y, circle.radius)

	for i, e in ipairs(waves) do
		love.graphics.circle('line', circle.x, circle.y, e)
	end

	local font = love.graphics.getFont()

	love.graphics.setColor(1,1,1)
	love.graphics.print(
		number.value,
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
		love.filesystem.write('score', number.value)
	end
end

function love.quit()
	love.filesystem.write('score', number.value)
end
