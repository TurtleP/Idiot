--Function hooks/Callbacks
local analogFade = 0
local oldupdate = love.update
function love.update(dt)
	if analogStick then
		if not analogStick:isHeld() then
			analogFade = math.max(analogFade - 0.6 * dt, 0)

			love.keyreleased(controls["up"])
			love.keyreleased(controls["down"])
			love.keyreleased(controls["right"])
			love.keyreleased(controls["left"])
		else
			analogFade = 1
		end

		analogStick.areaColor = {255, 255, 255, 150 * analogFade}
		analogStick.stickColor = {42, 42, 42, 240 * analogFade}
	end

	oldupdate(dt)
	
	touchControls:update(dt)

	if state == "game" then
		if objects["player"][1] then
			local v = objects["player"][1]

			if v.screen == "bottom" then
				mapScrollY = math.min(mapScrollY + 480 * dt, 240)
			else
				mapScrollY = math.max(mapScrollY - 480 * dt, 0)
			end
		end
	end
end

function love.touchpressed(id, x, y, pressure)
	touchControls:touchpressed(id, x, y, pressure)
end

function love.touchreleased(id, x, y, pressure)
	touchControls:touchreleased(id, x, y, pressure)
end

function love.touchmoved(id, x, y, pressure)
	if analogStick:isHeld() then
		analogFade = 1
	end

	analogStick:touchMoved(id, x, y, pressure)
end

touchcontrol = class("touchcontrol")

function touchcontrol:init()
	require 'mobile/analog'
	require 'mobile/virtualbutton'

	analogStick = newAnalog(52 * scale, (gameFunctions.getHeight() - 60) * scale, 36 * scale, 12 * scale, 0.5)

	self.buttons =
	{
		virtualbutton:new(love.graphics.getWidth() - 120, gameFunctions.getHeight() - 60, "A", controls["jump"], nil, true, true),
		virtualbutton:new(love.graphics.getWidth() - 60, gameFunctions.getHeight() - 60, "B", controls["use"], nil, true, true)
	}
end

function touchcontrol:touchpressed(id, x, y, pressure)
	if state ~= "game" then
		return
	end

	if aabb(gameFunctions.getWidth() - 18, 0, 18, 18, x / scale, y / scale, 8, 8) then
		return
	end

	for k, v in ipairs(self.buttons) do
		v:touchPressed(id, x, y, pressure)

		if aabb(v.x, v.y, v.width, v.height, x / scale, y / scale, 8, 8) then
			return
		end
	end

	if not analogStick:isHeld() then
		analogStick.cx, analogStick.cy = x, y
	else
		analogFade = 1
	end

	analogStick:touchPressed(id, x, y, pressure)
end

function touchcontrol:update(dt)
	if state ~= "game" then
		return
	end

	analogStick:update(dt)

	if not analogStick:isHeld() then
		analogFade = math.max(analogFade - 0.6 * dt, 0)

		love.keyreleased(controls["up"])
		love.keyreleased(controls["down"])
		love.keyreleased(controls["right"])
		love.keyreleased(controls["left"])
	else
		analogFade = 1

		if state == "game" and not paused then
			if analogStick:getX() > 0.5 then
				love.keypressed(controls["right"])
				love.keyreleased(controls["left"])
			end

			if (analogStick:getX() >= 0 and analogStick:getX() <= 0.5) or (analogStick:getX() >= -0.5 and analogStick:getX() <= 0) then
				love.keyreleased(controls["right"])
				love.keyreleased(controls["left"])
			end

			if analogStick:getX() < -0.5 then
				love.keypressed(controls["left"])
				love.keyreleased(controls["right"])
			end

			if (analogStick:getY() >= 0 and analogStick:getY() <= 0.5) or (analogStick:getY() >= -0.5 and analogStick:getY() <= 0) then
				love.keyreleased(controls["up"])
				love.keyreleased(controls["down"])
			end

			if analogStick:getY() > 0.5 then
				love.keypressed(controls["down"])
				love.keyreleased(controls["up"])
			end

			if analogStick:getY() < -0.5 then
				love.keypressed(controls["up"])
				love.keyreleased(controls["down"])
			end

		end
	end
end

function touchcontrol:touchreleased(id, x, y, pressure)
	analogStick:touchReleased(id, x, y, pressure)

	for k, v in ipairs(self.buttons) do
		v:touchReleased(id, x, y, pressure)
	end
end

function touchcontrol:draw()
	if state ~= "game" then
		return
	end

	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.setScreen("top")

	love.graphics.setScissor(0, 0, gameFunctions.getWidth() * scale, gameFunctions.getHeight() * scale)

	love.graphics.push()

	--love.graphics.translate(0, -math.floor(mapScrollY))

	analogStick:draw()

	love.graphics.push()

	--love.graphics.translate(0, -math.floor(mapScrollY))
	love.graphics.scale(scale, scale)
	
	for k, v in ipairs(self.buttons) do
		v:draw()
	end

	love.graphics.pop()

	love.graphics.pop()

	love.graphics.setScissor()

end

local oldDraw = love.draw
function love.draw()
	oldDraw()

	touchControls:draw()
end