function gameInit(loadGame)
	eventSystem = eventsystem:new()

	currentLevel = loadGame or 1

	outputs = {"plate", "pipe", "sensor", "logicgate", "box"}

	love.graphics.setBackgroundColor(67, 67, 67)

	gameHud = HUD:new()

	shakeIntensity = 0
	gameFade = 0
	otherFade = 1
	gameScreen = "top"
	fadeValue = 1

	pauseMenu = pausemenu:new()

	titleMusic:stop()

	titleMusic = nil

	collectgarbage()
	collectgarbage()

	backgroundMusic = love.audio.newSource("audio/bgm.ogg")
	backgroundMusic:setLooping(true)

	if not bossSong then
		bossSong = love.audio.newSource("audio/boss.ogg")
		bossSong:setLooping(true)
	end

	backgroundMusic:play()

	gameLoadMap(currentLevel)
end

function gameUpdate(dt)

	local x, y, w, h = 0, 0, 400, 248 
	if _EMULATEHOMEBREW then
		if love.graphics.getScreen() == "bottom" then
			x = 40
			y = 240
			w = 320
		end
	end
	cameraObjects = checkCamera(x, y, w, h)
	
	if paused then
		pauseMenu:update(dt)
		return
	end

	if gameFadeOut then
		if gameFade < 1 then
			gameFade = math.min(gameFade + fadeValue * dt, 1)
		else
			if fadeValue ~= 1 then
				fadeValue = 1
			end

			if gameFade == 1 and deathRestart then
				gameLoadMap(currentLevel, true)
			end
		end
	else
		if gameFade > 0 then
			gameFade = math.max(gameFade - fadeValue * dt, 0)
		else
			if fadeValue ~= 1 then
				fadeValue = 1
			end
		end
	end

	if shakeIntensity > 0 then
		shakeIntensity = shakeIntensity - 10 * dt
	end

	eventSystem:update(dt)

	gameHud:update(dt)

	physicsupdate(dt)

	if objects["player"][1] then
		if objects["player"][1].updateBox then
			objects["player"][1]:updateBox()
		end
	end
end

function getMapScrollY()
	if not objects then
		return 0
	end

	return mapScroll[objects["player"][1].screen][2]
end

function gameDraw()
	love.graphics.push()

		love.graphics.translate(0, -math.floor(mapScrollY))
		
		if shakeIntensity > 0 then
			love.graphics.translate( math.floor( (math.random() * 2 - 1) * shakeIntensity ), math.floor( (math.random() * 2 - 1) * shakeIntensity ) ) 
		end

		gameDrawEntities()
		
		love.graphics.setColor(255, 255, 255, 255)

		gameHud:draw()

	love.graphics.pop()
end

function restartMap(paused)
	gameFadeOut = true

	if paused then
		gameLoadMap(currentLevel)
		deathRestart = true
	else
		deathRestart = true
	end
end

function gameKeypressed(key)
	if key == controls["pause"] and not eventSystem:isRunning() then
		paused = not paused

		if paused then
			pauseSound:play()
		end
	end

	if paused then
		pauseMenu:keypressed(key)

		return
	end

	if #objects["player"] > 1 or  #objects["player"] == 0 then
		return
	end

	if not objects["player"][1].moveRight then
		return
	end

	if objects["player"][1].fade < 1 then
		return
	end

	if key == controls["jump"] then
		objects["player"][1]:dialogScroll()
	end

	if _LOCKPLAYER then
		return
	end

	if key == controls["right"] then
		objects["player"][1]:moveRight(true)
	end

	if key == controls["left"] then
		objects["player"][1]:moveLeft(true)
	end

	if key == controls["use"] then
		objects["player"][1]:useItem()
	end

	if key == controls["jump"] then
		objects["player"][1]:jump()
	end

	if key == controls["up"] then
		objects["player"][1]:moveUp(true)
	end

	if key == controls["down"] then
		objects["player"][1]:moveDown(true)
	end
end

function gameKeyreleased(key)
	if #objects["player"] > 1 or #objects["player"] == 0 then
		return
	end

	if not objects["player"][1].moveRight then
		return
	end

	if key == controls["right"] then
		objects["player"][1]:moveRight(false)
	end

	if key == controls["left"] then
		objects["player"][1]:moveLeft(false)
	end

	if key == controls["jump"] then
		objects["player"][1]:stopJump()
	end

	if key == controls["up"] then
		objects["player"][1]:moveUp(false)
	end

	if key == controls["down"] then
		objects["player"][1]:moveDown(false)
	end
end

function gameDrawEntities()
	local p = "top"
	local other = "bottom"
	if objects["player"][1] then
		p = objects["player"][1].screen

		if p == "top" then
			other = "bottom"
		elseif p == "bottom" then
			other = "top"
		end
	end
	
	love.graphics.setScreen(p)

	love.graphics.draw(backgroundImage[p], 0, 0)

	love.graphics.setScreen("top")
	love.graphics.draw(maps[currentLevel].top, 0, 0)

	if maps[currentLevel].bottom then
		love.graphics.setScreen("bottom")
		love.graphics.draw(maps[currentLevel].bottom, 0, 0)
	end

	for k = 1, #cameraObjects do
		if cameraObjects[k][2].screen == p then
			local obj = cameraObjects[k][2]
			if obj.draw then
				obj:draw()
			end
		end
	end

	love.graphics.push()

	love.graphics.origin()
	love.graphics.scale(scale, scale)
	love.graphics.setScreen(p)
	love.graphics.setColor(0, 0, 0, 255 * gameFade)
	love.graphics.rectangle("fill", 0, 0, gameFunctions.getWidth(), gameFunctions.getHeight())

	love.graphics.setScreen(other)
	love.graphics.setColor(0, 0, 0, 255 * otherFade)
	love.graphics.rectangle("fill", 0, 0, gameFunctions.getWidth(), gameFunctions.getHeight())

	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.pop()

	if paused then
		pauseMenu:draw()
	end
end

function gameAddUseRectangle(x, y, width, height, self)
	local t = {}
	t.x = x
	t.y = y
	t.width = width
	t.height = height
	t.callback = self
	t.delete = false
	
	table.insert(objectUseRectangles, t)
	return t
end

function gameUseRectangle(x, y, width, height)
	local ret = {}
	
	for i, v in pairs(objectUseRectangles) do
		if aabb(x, y, width, height, v.x, v.y, v.width, v.height) then
			table.insert(ret, v.callback)
		end
	end
	
	return ret
end

function gameNextLevel()
	if maps[currentLevel + 1] then
		table.remove(objects["player"], 1)
		deathRestart = false
		gameLoadMap(currentLevel + 1)
	else
		gameFunctions.changeState("title")
	end	
end

function insideCamera(self)
	return (self.x + self.width < getMapScrollX() or self.x > gameFunctions.getWidth() + getMapScrollX())
end

function gameLoadObjects(decrypt)
	objects = {}

	objects["tile"] = {}
	objects["player"] = {}
	objects["box"] = {}
	objects["key"] = {}
	objects["plate"] = {}
	objects["fan"] = {}
	objects["fanparticle"] = {}
	objects["door"] = {}
	objects["spikes"] = {}
	objects["dialog"] = {}
	objects["pipe"] = {}
	objects["sensor"] = {}
	objects["laser"] = {}
	objects["logicgate"] = {}
	objects["enemy"] = {}
	objects["lava"] = {}
	objects["bomb"] = {}

	objectUseRectangles = {}

	tileData = {}
	tileLinks = {}
	mapDimensions = {}
	mapScroll = { ["top"] = {0, 0}, ["bottom"] = {0, 0} }
	mapScrollY = 0

	shakeIntensity = 0

	gameFadeOut = false

	if not decrypt then
		return
	end

	for k = 1, #mapScripts do
		if k ~= 6 then
			eventSystem:decrypt(mapScripts[k])
		end
	end
end

function gameLoadMap(map, decrypt)
	currentLevel = map

	if bossSong:isPlaying() then
		bossSong:stop()
	end

	local decrypt = decrypt
	if not decrypt then
		decrypt = true
	end
	gameLoadObjects(decrypt)

	local newMap = maps[map].map

	local mapData = newMap.layers

	for k, v in ipairs(mapData) do
		if v.type == "tilelayer" then
			loadTiles(v.width, v.height, v.properties, v.data, v.name)
		else
			if v.name == "topObjects" then
				loadObjects(v.objects, "top")
			elseif v.name == "bottomObjects" then
				loadObjects(v.objects, "bottom")
			end
		end
	end
end

function loadObjects(objectData, screen)
	for j, w in pairs(objectData) do
		if not w.properties.link then
			w.properties.link = ""
		end

		if w.name == "door" then
			table.insert(objects["door"], door:new(w.x, w.y - 16, w.properties, screen))

			if w.properties.start == "true" then
				_PLAYERSPAWNX, _PLAYERSPAWNY = w.x, w.y
				objects["player"][1] = player:new(w.x, w.y)
			end
		elseif w.name == "pipe" then
			table.insert(objects["pipe"], pipe:new(w.x, w.y, w.properties, screen))
		elseif w.name == "box" then
			table.insert(objects["box"], box:new(w.x, w.y, w.properties, screen))
		elseif w.name == "button" then
			table.insert(objects["button"], button:new(w.x, w.y, w.properties, screen))
		elseif w.name == "fan" then
			table.insert(objects["fan"], fan:new(w.x, w.y, w.properties, screen))
		elseif w.name == "key" then
			table.insert(objects["key"], key:new(w.x + 6, w.y, screen))
		elseif w.name == "pressureplate" then
			table.insert(objects["plate"], plate:new(w.x, w.y, screen))
		elseif w.name == "spikes" then
			table.insert(objects["spikes"], spikes:new(w.x, w.y + 8, w.width, screen))
		elseif w.name == "sensor" then
			table.insert(objects["sensor"], sensor:new(w.x, w.y, w.properties, screen))
		elseif w.name == "dropper" then
			table.insert(objects["dropper"], dropper:new(w.x, w.y, w.properties, screen))
		elseif w.name == "laser" then
			table.insert(objects["laser"], laser:new(w.x + 7.5, w.y, w.properties, screen))
		elseif w.name == "lava" then
			table.insert(objects["lava"], lava:new(w.x, w.y + 8, w.width, screen))
		elseif w.name == "spawn" then
			_PLAYERSPAWNX, _PLAYERSPAWNY = w.x, w.y
		elseif w.name == "notgate" then
			table.insert(objects["logicgate"], notgate:new(w.x, w.y, w.properties, screen))
		elseif w.name == "delayer" then
			table.insert(objects["logicgate"], delayer:new(w.x, w.y, w.properties, screen))
		elseif w.name == "andgate" then
			table.insert(objects["logicgate"], andgate:new(w.x, w.y, w.properties, screen))
		end
	end

	for k, v in pairs(objects) do
		for j, w in pairs(v) do
			if w.addLink then
				if w.link and #w.link > 0 then
					w:addLink()
				end
			end
		end
	end
end

function loadTiles(mapWidth, mapHeight, properties, mapData, screen)
	local w, h = 0, 16
	local pos = {}
	local first = false
	
	mapDimensions[screen] = {tonumber(properties.width), tonumber(properties.height)}

	--map loop (tiles)
	for y = 1, mapHeight do
		for x = 1, mapWidth do
			local r = mapData[(y - 1) * mapWidth + x]

			if r == 1 then
				--found a tile, add width
				w = w + 16
				
				--store START positions because it's big fuckin tile.. sometimes
				if not first then
					table.insert(pos, {x, y, 0, 16})
					first = true
				end
			elseif r > 1 then
				table.insert(objects["tile"], tile:new((x - 1) * 16, (y - 1) * 16, 16, 16, screen, r))
			end

			if first then
				if r ~= 1 then
					pos[#pos][3] = w
					w = 0
					first = false
				end
			end
		end

		--We made it to another level of the map on the y coord. Time to reset/store again
		if first then
			pos[#pos][3] = w
			w = 0
			first = false
		end
	end
	
	for k = 1, #pos do
		table.insert(objects["tile"], tile:new((pos[k][1] - 1) * 16, (pos[k][2] - 1) * 16, pos[k][3], pos[k][4], screen, 1))
	end
end