function love.touchpressed(id, x, y, pressure)
	touchControls:touchpressed(id, x, y, pressure)
end

function love.touchreleased(id, x, y, pressure)
	touchControls:touchreleased(id, x, y, pressure)
end

function love.touchmoved(id, x, y, pressure)
	directionPad:touchMoved(id, x, y, pressure)
end

--[[
	CUSTOM STUFF BELOW HERE
--]]