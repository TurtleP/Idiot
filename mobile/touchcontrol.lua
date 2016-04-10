touchcontrol = class("touchcontrol")

function touchcontrol:init()
	require 'mobile/dinput'
	require 'mobile/virtualbutton'
	require 'mobile/mobile'

	directionPad = dinput:new(10, love.graphics.getHeight() * 0.60, {controls["up"], controls["right"], controls["down"], controls["left"]})

	self.buttons =
	{
		virtualbutton:new(gameFunctions.getWidth() * 0.8, gameFunctions.getHeight() * 0.82, "A", controls["jump"], {"onRelease"}),
		virtualbutton:new(gameFunctions.getWidth() * 0.9, gameFunctions.getHeight() * 0.72, "B", controls["use"])
	}
end

function touchcontrol:touchpressed(id, x, y, pressure)
	if aabb(gameFunctions.getWidth() - 18, 0, 18, 18, x / scale, y / scale, 8, 8) then
		return
	end

	for k, v in ipairs(self.buttons) do
		v:touchPressed(id, x, y, pressure)

		if aabb(v.x, v.y, v.width, v.height, x / scale, y / scale, 8, 8) then
			return
		end
	end

	directionPad:touchPressed(id, x, y, pressure)
end

function touchcontrol:touchreleased(id, x, y, pressure)
	directionPad:touchReleased(id, x, y, pressure)

	for k, v in ipairs(self.buttons) do
		v:touchReleased(id, x, y, pressure)
	end
end

function touchcontrol:draw()
	if state == "intro" then
		return
	end

	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.setScreen("top")

	love.graphics.setScissor(0, 0, gameFunctions.getWidth() * scale, gameFunctions.getHeight() * scale)

	love.graphics.push()

	love.graphics.scale(scale, scale)

	directionPad:draw()
	
	for k, v in ipairs(self.buttons) do
		v:draw()
	end

	love.graphics.pop()

	love.graphics.setScissor()

end

local oldDraw = love.draw
function love.draw()
	oldDraw()

	touchControls:draw()
end