if love.system.getOS() ~= "3ds" then
	_SCREEN = "top"

	function love.graphics.setScreen(screen)
		_SCREEN = screen

		if screen == "top" then
			love.graphics.setScissor(0, -(mapScrollY * scale), 400 * scale, 240 * scale)
			love.graphics.print("FPS: " .. love.timer.getFPS(), love.graphics.getWidth() - signFont:getWidth("FPS: " .. love.timer.getFPS()) - 2, 6 * scale)
		elseif screen == "bottom" then
			love.graphics.setScissor(40 * scale, (240 * scale) - (mapScrollY * scale), 320 * scale, 240 * scale)
			love.graphics.print("FPS: " .. love.timer.getFPS(), love.graphics.getWidth() - signFont:getWidth("FPS: " .. love.timer.getFPS()) - 2, 6 * scale)
		end
	end

	function love.graphics.getWidth()
		if love.graphics.getScreen() == "bottom" then
			return 320
		end
		return 400
	end

	function love.graphics.getHeight()
		return 240
	end

	function love.graphics.getScreen()
		return _SCREEN
	end

	local oldclear = love.graphics.clear
	function love.graphics.clear(r, g, b, a)
		love.graphics.setScissor()

		oldclear(r, g, b, a)
	end
end

if love.system.getOS() == "3ds" or _EMULATEHOMEBREW then

	--[[
		"a", "b", "select", "start",
		"dright", "dleft", "dup", "ddown",
		"rbutton", "lbutton", "x", "y",
		"", "", "lzbutton", "rzbutton",
		"", "", "", "",
		"touch", "", "", "",
		"cstickright", "cstickleft", "cstickup", "cstickdown",
		"cpadright", "cpadleft", "cpadup", "cpaddown"
	--]]

	if not _EMULATEHOMEBREW then
		love.graphics.scale = function() end
		love.math = { random = math.random }
		love.graphics.setDefaultFilter = function() end
		love.audio.setVolume = function() end
	else
		local olddraw = love.graphics.draw
		function love.graphics.draw(...)
			local args = {...}

			local image = args[1]
			local quad
			local x, y, r
			local scalex, scaley

			if type(args[2]) == "userdata" then
				quad = args[2]
				x = args[3]
				y = args[4]
				scalex, scaley = args[5], args[6]
			else
				x, y = args[2], args[3]
				r = args[4]
			end

			if love.graphics.getScreen() == "bottom" then
				x = x + 40
				y = y + 240
			end

			if not quad then
				if r then
					olddraw(image, x + image:getWidth() / 2, y + image:getHeight() / 2, r, 1, 1, image:getWidth() / 2, image:getHeight() / 2)
				else
					olddraw(image, x, y)
				end
			else
				olddraw(image, quad, x, y, 0, scalex, scaley)
			end
		end

		local oldRectangle = love.graphics.rectangle
		function love.graphics.rectangle(mode, x, y, width, height)
			if love.graphics.getScreen() == "bottom" then
				x = x + 40
				y = y + 240
			end
			oldRectangle(mode, x, y, width, height)
		end

		local oldCircle = love.graphics.circle
		function love.graphics.circle(mode, x, y, r, segments)
			if love.graphics.getScreen() == "bottom" then
				x = x + 40
				y = y + 240
			end
			oldCircle(mode, x, y, r, segments)
		end

		local oldPrint = love.graphics.print
		function love.graphics.print(text, x, y, r, scalex, scaley, sx, sy)
			if love.graphics.getScreen() == "bottom" then
				x = x + 40
				y = y + 240
			end
			oldPrint(text, x, y, r, scalex, scaley, sx, sy)
		end
		
	end
end