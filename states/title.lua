function titleInit()
	love.graphics.setBackgroundColor(255, 255, 255)

	idiotChar = player:new(-13, gameFunctions.getHeight() - 48)
	idiotChar:walk("right", 206)

	titleY = -titleLogo:getHeight()
	titleTimer = 0

	titleDoSine = false

	titleState = "main"

	titleOptions =
	{
		{"New Game", 
			function()
				gameFunctions.changeState("game") 
			end
		},
		{"View Options", 
			function() 
				titleState = "options" 
			end
		},
		{"Quit Idiot", love.event.quit}
	}

	if love.filesystem.isFile("save.txt") then
		titleOptions[1] = {"Continue Game", loadGame}
	end

	titleSelection = 1

	titleSineValue = 1
	titleSineTimer = 0

	optionsFade = 1

	currentOption = 1
	optionsScroll = 2
	optionsScrollTimer = 0

	setControls = {false, false}

	titleSettings =
	{
		toggleDPad,

		function()
		end,

		function()
		end,

		function()
			setControls = {true, "jump"}
		end,

		function()
			setControls = {true, "use"}
		end
	}

	optionsDescriptions =
	{
		"Enable D-Pad for movement. Disables Circle-Pad.",
		"Erase all save data. Cannot be undone!",
		"Display the credits."
	}

	bossSong = nil

	if not titleMusic then
		titleMusic = love.audio.newSource("audio/title.wav", "stream")
	end
	
	backgroundMusic:stop()
end

function titleUpdate(dt)
	if not titleMusic:isPlaying() then
		titleMusic:play()
	end

	idiotChar:update(dt)

	idiotChar.x = idiotChar.x + idiotChar.speedx * dt

	if not titleDoSine then
		titleTimer = titleTimer + dt
		if titleTimer > 2 then
			titleY = math.min(titleY + 120 * dt, gameFunctions.getHeight() * 0.30)
			if titleY == gameFunctions.getHeight() * .30 then
				titleDoSine = true
			end
		end
	else
		titleSineTimer = titleSineTimer + 0.5 * dt
		titleSineValue = math.abs( math.sin( titleSineTimer * math.pi ) / 2 ) + 0.5

		if titleState == "select" then
			--who cares, default or whatever
			optionsFade = math.min(optionsFade + .6 * dt, 1)
		elseif titleState == "options" then
			optionsFade = math.max(optionsFade - .6 * dt, 0)

			if optionsDescriptions[currentOption] then
				optionsScrollTimer = optionsScrollTimer + dt
				if optionsScrollTimer > 1 then
					optionsScroll = optionsScroll - 48 * dt

					if optionsScroll + signFont:getWidth(optionsDescriptions[currentOption]) < 0 then
						optionsScroll = gameFunctions.getWidth()
					end
				end
			end
		end
	end
end

function titleDraw()
	love.graphics.setScreen("top")

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(backgroundImage.top)

	love.graphics.draw(titleImage, 0, 0)

	local off = 0
	if titleDoSine then
		off = math.sin(love.timer.getTime()) * 6
	end

	love.graphics.draw(titleLogo, gameFunctions.getWidth() / 2 - titleLogo:getWidth() / 2, math.floor(titleY + off))

	love.graphics.setFont(signFont)

	if titleState == "main" then
		if titleDoSine then
			shadowPrint("Press any button", gameFunctions.getWidth() / 2 - signFont:getWidth("Press any button") / 2, gameFunctions.getHeight() * .60)
		end
	else
		for k = 1, #titleOptions do
			local v, mul = titleOptions[k], 1
			if k == titleSelection then
				mul = titleSineValue
			end

			shadowPrint(v[1], gameFunctions.getWidth() / 2 - signFont:getWidth(v[1]) / 2, gameFunctions.getHeight() * .55 + (k - 1) * 16, mul)
		end
	end

	shadowPrint(buildVersion, 0, gameFunctions.getHeight() - signFont:getHeight(buildVersion))

	idiotChar:draw()

	love.graphics.setScreen("bottom")

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(backgroundImage.bottom, 0, 0)
	love.graphics.draw(optionsImage, 0, 0)

	shadowPrint(":: Options ::", gameFunctions.getWidth() / 2 - signFont:getWidth(":: Options ::") / 2, 26 - signFont:getHeight(":: Options ::") / 2)

	shadowPrint("[General]", 24, 50)
	local mul = 1
	if currentOption == 1 then
		mul = titleSineValue
	end
	shadowPrint("Enable D-Pad: " .. tostring(directionalPadEnabled):gsub("^%l", string.upper), 24, 68, mul)

	local mul = 1
	if currentOption == 2 then
		mul = titleSineValue
	end
	shadowPrint("Erase save data", 24, 84, mul)

	local mul = 1
	if currentOption == 3 then
		mul = titleSineValue
	end
	shadowPrint("View credits", 24, 100, mul)

	shadowPrint("[Controls]", 24, 132)

	local mul = 1
	if currentOption == 4 then
		mul = titleSineValue
	end
	shadowPrint("Jump/Advance dialog: " .. controls["jump"]:gsub("^%l", string.upper), 24, 148, mul)
		
	local mul = 1
	if currentOption == 5 then
		mul = titleSineValue
	end
	shadowPrint("Pick up items: " .. controls["use"]:gsub("^%l", string.upper), 24, 164, mul)

	if optionsDescriptions[currentOption] then
		love.graphics.setColor(0, 0, 0, 200)
		love.graphics.rectangle("fill", 0, gameFunctions.getHeight() - 15, gameFunctions.getWidth(), 14)

		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print(optionsDescriptions[currentOption], optionsScroll, (gameFunctions.getHeight() - 6) - signFont:getHeight(optionsDescriptions[currentOption]) / 2)
	end

	love.graphics.setColor(0, 0, 0, 255 * optionsFade)
	love.graphics.rectangle("fill", 0, 0, gameFunctions.getWidth(), gameFunctions.getHeight())
end

function shadowPrint(text, x, y, a)
	local alpha = a or 1
	love.graphics.setColor(0, 0, 0, 255 * alpha)
	love.graphics.print(text, x - 1, y - 1)
	love.graphics.setColor(255, 255, 255, 255 * alpha)
	love.graphics.print(text, x, y)
end

function titleKeypressed(key)
	if setControls[1] then
		if key == controls["pause"] then
			setControls = {false, false}
		else
			controls[setControls[2]] = key
			setControls = {false, false}
		end

		return
	end

	if titleState == "main" then
		if titleDoSine then
			titleState = "select"
			return
		end
	end
		
	if key == controls["up"] then
		if titleState == "select" then 
			titleChangeSelection(-1)
		elseif titleState == "options" then
			titleChangeOptions(-1)
		end
	elseif key == controls["down"] then
		if titleState == "select" then
			titleChangeSelection(1)
		elseif titleState == "options" then
			titleChangeOptions(1)
		end
	elseif key == "a" then
		if titleState == "select" then
			titleOptions[titleSelection][2]()
		elseif titleState == "options" then
			titleSettings[currentOption]()
		end
	end

	if key == "b" then
		if titleState == "select" then
			titleState = "main"
		elseif titleState == "options" then
			titleState = "select"
			saveSettings()
		elseif titleState == "credits" then
			titleState = "options"
		end
	end
end

function titleChangeSelection(step)
	if titleSelection + step > 1 and titleSelection + step < #titleOptions then
		titleSineTimer = 0
	end

	titleSelection = math.clamp(1, titleSelection + step, #titleOptions)
end

function titleChangeOptions(step)
	currentOption = math.clamp(1, currentOption + step, 5)

	optionsScroll = 2
	optionsScrollTimer = 0
end