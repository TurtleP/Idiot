if love.system.getOS() ~= "3ds" then
	_SCREEN = "top"

	function love.graphics.setScreen(screen)
		assert(type(screen) == "string", "String expected, got " .. type(screen))
		_SCREEN = screen

		if screen == "top" then
			love.graphics.setScissor(0, -(mapScrollY or 0 * scale), 400 * scale, 240 * scale)
		elseif screen == "bottom" then
			love.graphics.setScissor(40 * scale, (240 * scale) - (mapScrollY or 0 * scale), 320 * scale, 240 * scale)
		end
	end

	function love.graphics.getWidth()
		if love.graphics.getScreen() == "bottom" then
			return 320
		end
		return 400
	end

	local oldSetColor = love.graphics.setColor
	function love.graphics.setColor(r, g, b, a)
		if type(r) == "table" then
			oldSetColor(unpack(r))
		else
			oldSetColor(r, g, b, a)
		end
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

	local _KEYNAMES =
	{
		"a", "b", "select", "start",
		"dright", "dleft", "dup", "ddown",
		"rbutton", "lbutton", "x", "y",
		"lzbutton", "rzbutton", "cstickright", 
		"cstickleft", "cstickup", "cstickdown",
		"cpadright", "cpadleft", "cpadup", "cpaddown"
	}

	local _CONFIG =
	{
		["a"] = "u",
		["b"] = "i",
		["y"] = "o",
		["x"] = "p",
		["start"] = "return",
		["select"] = "rshift",
		["dup"] = "up",
		["dleft"] = "left",
		["dright"] = "right",
		["ddown"] = "down",
		["rbutton"] = "/",
		["lbutton"] = "rcontrol",
		["cpadright"] = "d",
		["cpadleft"] = "a",
		["cpadup"] = "w",
		["cpaddown"] = "s",
		["cstickleft"] = "",
		["cstickright"] ="",
		["cstickup"] = "",
		["cstickdown"] = ""
	}

	--[[if love.keypressed then
		local oldKeyPressed = love.keypressed
		function love.keypressed(key)
			for k = 1, #_KEYNAMES do
				if _CONFIG[_KEYNAMES[k] == key then
					oldKeyPressed(_KEYNAMES[k])
				end
			end
		end
	end

	if love.keyreleased then
		local oldKeyReleased = love.keyreleased
		function love.keyreleased(key)
			for k = 1, #_KEYNAMES do
				if _CONFIG[_KEYNAMES[k] == key then
					oldKeyReleased(_KEYNAMES[k])
				end
			end
		end
	end]]

	-- Clamps a number to within a certain range.
	function math.clamp(low, n, high) 
		return math.min(math.max(low, n), high) 
	end

	local oldMousePressed = love.mousepressed
	function love.mousepressed(x, y, button)
		x, y = math.clamp(0, x - 40, 320), math.clamp(0, y - 240, 240)

		if oldMousePressed then
			oldMousePressed(x, y, 1)
		end
	end

	local oldMouseReleased = love.mousereleased
	function love.mousereleased(x, y, button)
		x, y = math.clamp(0, x - 40, 320), math.clamp(0, y - 240, 240)

		if oldMouseReleased then
			oldMouseReleased(x, y, 1)
		end
	end

	love.window.setMode(400 * scale, 480 * scale, {vsync = true})
end

if love.system.getOS() == "3ds" or _EMULATEHOMEBREW then

	if not love.filesystem then
		love.filesystem = {}

		love.filesystem.exists = function(path) return io.open(path) ~= nil end
	end

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