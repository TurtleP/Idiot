function gameInit()
	eventSystem = eventsystem:new()

	currentLevel = 1

	outputs = {"plate", "button", "pipe", "teleporter", "sensor", "logicgate"}

	gameLoadMap(currentLevel)

	love.graphics.setBackgroundColor(67, 67, 67)

	gameHud = HUD:new()

	shakeIntensity = 0
	gameFade = 0
	otherFade = 1
	gameScreen = "top"
end

function gameUpdate(dt)
	if not bgm:isPlaying() then
		bgm:play()
	end

	for k, v in pairs(objects) do
		for j, w in pairs(v) do
			if w.update then
				w:update(dt)
			end

			if w.remove then
				for k, v in pairs(objectUseRectangles) do
					if v.callback == w then
						table.remove(objectUseRectangles, k)
					end
				end
				table.remove(objects[k], j)
			end
		end
	end

	if gameFadeOut then
		gameFade = math.min(gameFade + 2 * dt, 1)
	else
		gameFade = math.max(gameFade - 2 * dt, 0)
	end

	if shakeIntensity > 0 then
		shakeIntensity = shakeIntensity - 10 * dt
	end

	eventSystem:update(dt)

	gameHud:update(dt)

	cameraScroll()

	physicsupdate(dt)

	if objects["player"][1] then
		if objects["player"][1].updateBox then
			objects["player"][1]:updateBox()
		end
	end
end

function cameraScroll()
	if #objects["player"] == 0 or #objects["player"] > 1 then
		return
	end

	local self = objects["player"][1]

	--==HORIZONTAL SCROLL==--

	local _MAPWIDTH = mapDimensions[self.screen][1]

	if _MAPWIDTH > 25 then
		if mapScroll[self.screen][1] >= 0 and mapScroll[self.screen][1] + gameFunctions.getWidth(self.screen) <= (_MAPWIDTH - 1) * 16 then
			if self.x > mapScroll[self.screen][1] + gameFunctions.getWidth(self.screen) * 1 / 2 then
				mapScroll[self.screen][1] = self.x - gameFunctions.getWidth(self.screen) * 1 / 2
			elseif self.x < mapScroll[self.screen][1] + gameFunctions.getWidth(self.screen) * 1 / 2 then
				mapScroll[self.screen][1] = self.x - gameFunctions.getWidth(self.screen) * 1 / 2
			end
		end

		if mapScroll[self.screen][1] < 0 then
			mapScroll[self.screen][1] = 0
		elseif mapScroll[self.screen][1] + gameFunctions.getWidth(self.screen) >= (_MAPWIDTH - 1) * 16 then
			mapScroll[self.screen][1] = (_MAPWIDTH - 1) * 16 - gameFunctions.getWidth(self.screen)
		end
	end

	--==VERTICAL SCROLL==--

	local _MAPHEIGHT = mapDimensions[self.screen][2]

	if mapScroll[self.screen][2] >= 0 and mapScroll[self.screen][2] + gameFunctions.getHeight() <= (_MAPHEIGHT) * 16 then
		if self.y + self.height / 2 > mapScroll[self.screen][2] + gameFunctions.getHeight() * 1 / 2 then
			mapScroll[self.screen][2] = self.y + self.height / 2 - gameFunctions.getHeight() * 1 / 2
		elseif self.y + self.height / 2 < mapScroll[self.screen][2] + gameFunctions.getHeight() * 1 / 2 then
			mapScroll[self.screen][2] = self.y + self.height / 2 - gameFunctions.getHeight() * 1 / 2
		end
	end

	if mapScroll[self.screen][2] < 0 then
		mapScroll[self.screen][2] = 0
	elseif mapScroll[self.screen][2] + gameFunctions.getHeight() >= (_MAPHEIGHT) * 16 then
		mapScroll[self.screen][2] = (_MAPHEIGHT) * 16 - gameFunctions.getHeight()
	end
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

function gameKeypressed(key)
	if #objects["player"] > 1 or  #objects["player"] == 0 then
		return
	end

	if not objects["player"][1].moveRight then
		return
	end

	if objects["player"][1].fade < 1 then
		return
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

	love.graphics.push()

	love.graphics.setScreen(p)

	for x = 1, math.floor(mapDimensions[p][1] / (backgroundImage[p]:getWidth() / 16)) + 1 do
		love.graphics.draw(backgroundImage[p], (x - 1) * backgroundImage[p]:getWidth(), 0)
	end

	love.graphics.pop()

	for k, v in pairs(objects["sensor"]) do
		if v.screen == p then
			if v.draw then
				v:draw()
			end
		end
	end
	
	for k, v in pairs(objects["tile"]) do
		if v.screen == p then
			v:draw()
		end
	end

	for k, v in pairs(objects["logicgate"]) do
		if v.screen == p then
			v:draw()
		end
	end

	for k, v in pairs(objects["door"]) do
		if v.screen == p then
			v:draw()
		end
	end

	for k, v in pairs(objects["teleporter"]) do
		if v.screen == p then
			v:draw()
		end
	end

	for k, v in pairs(objects["plate"]) do
		if v.screen == p then
			v:draw()
		end
	end

	for k, v in pairs(objects["sign"]) do
		if v.screen == p then
			v:draw()
		end
	end

	for k,v in pairs(objects["spikes"]) do
		if v.screen == p then
			v:draw()
		end
	end

	for k, v in pairs(objects["key"]) do
		if v.screen == p then
			v:draw()
		end
	end

	for k, v in pairs(objects["fan"]) do
		if v.screen == p then
			v:draw()
		end
	end

	for k, v in pairs(objects["player"]) do
		if v.screen == p then
			v:draw()
		end
	end

	for k, v in pairs(objects["laser"]) do
		if v.screen == p then
			v:draw()
		end
	end

	for k, v in pairs(objects["box"]) do
		if v.screen == p then
			v:draw()
		end
	end

	for k, v in pairs(objects["dropper"]) do
		if v.screen == p then
			v:draw()
		end
	end

	for k, v in pairs(objects["pipe"]) do
		if v.screen == p then
			v:draw()
		end
	end
	
	for k, v in pairs(objects["button"]) do
		if v.screen == p then
			v:draw()
		end
	end

	for k, v in pairs(objects["dialog"]) do
		if v.screen == p then
			v:draw()
		end
	end

	love.graphics.push()

	love.graphics.origin()
	love.graphics.setScreen(p)
	love.graphics.setColor(0, 0, 0, 255 * gameFade)
	love.graphics.rectangle("fill", 0, 0, gameFunctions.getWidth() * scale, gameFunctions.getHeight() * scale)

	love.graphics.setScreen(other)
	love.graphics.setColor(0, 0, 0, 255 * otherFade)
	love.graphics.rectangle("fill", 0, 0, gameFunctions.getWidth() * scale, gameFunctions.getHeight() * scale)

	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.pop()
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
	if _EMULATEHOMEBREW then
		read = love.filesystem.isFile
		path = "maps/" .. currentLevel + 1 .. ".lua"
	else
		read = io.open
		path = "sdmc:/3ds/Idiot/game/maps/" .. currentLevel + 1 .. ".lua"
	end

	if read(path) then
		table.remove(objects["player"], 1)
		gameLoadMap(currentLevel + 1)
	end
end

function pushPop(self, start)
	local v
	if objects["player"][1] then
		v = objects["player"][1]
	end

	if not v then
		return
	else
		if start then
			if self.screen == v.screen then
				love.graphics.push()
			
				love.graphics.translate(-math.floor(mapScroll[self.screen][1]), -math.floor(mapScroll[self.screen][2]))
			else
				love.graphics.push()

				love.graphics.translate(-math.floor(mapScroll[self.screen][1]), -math.floor(mapScroll[self.screen][2]))
			end
		else
			love.graphics.pop()
		end
	end
end

function gameLoadObjects()
	objects = {}

	objects["tile"] = {}
	objects["player"] = {}
	objects["sign"] = {}
	objects["box"] = {}
	objects["key"] = {}
	objects["plate"] = {}
	objects["fan"] = {}
	objects["door"] = {}
	objects["teleporter"] = {}
	objects["spikes"] = {}
	objects["dialog"] = {}
	objects["pipe"] = {}
	objects["button"] = {}
	objects["sensor"] = {}
	objects["dropper"] = {}
	objects["laser"] = {}
	objects["logicgate"] = {}

	objectUseRectangles = {}

	tileData = {}
	tileLinks = {}
	mapDimensions = {}
	mapScroll = { ["top"] = {0, 0}, ["bottom"] = {0, 0} }
	mapScrollY = 0

	shakeIntensity = 0

	for k = 1, #mapScripts do
		eventSystem:decrypt(mapScripts[k])
	end
end

function gameLoadMap(map)
	currentLevel = map

	gameLoadObjects()

	local newMap = require("maps/" .. map)

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
		elseif w.name == "sign" then
			table.insert(objects["sign"], sign:new(w.x, w.y, w.properties, screen))
		elseif w.name == "spikes" then
			table.insert(objects["spikes"], spikes:new(w.x, w.y + 8, screen))
		elseif w.name == "teleporter" then
			table.insert(objects["teleporter"], teleporter:new(w.x, w.y - 16, w.properties, screen))
		elseif w.name == "sensor" then
			table.insert(objects["sensor"], sensor:new(w.x, w.y, w.properties, screen))
		elseif w.name == "dropper" then
			table.insert(objects["dropper"], dropper:new(w.x, w.y, w.properties, screen))
		elseif w.name == "laser" then
			table.insert(objects["laser"], laser:new(w.x + 7.5, w.y, w.properties, screen))
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
	local w, h = {solid = 0, passive = 0}, 16
	local pos = { solid = {}, passive = {} }
	local first = {false, false}
	
	mapDimensions[screen] = {tonumber(properties.width), tonumber(properties.height)}

	--map loop (tiles)
	for y = 1, mapHeight do
		for x = 1, mapWidth do
			local r = mapData[(y - 1) * mapWidth + x]

			if r == 1 then
				--found a tile, add width
				w.solid = w.solid + 16
				
				--store START positions because it's big fuckin tile.. sometimes
				if not first[1] then
					table.insert(pos.solid, {x, y, 0, 16})
					first[1] = true
				end
			end

			if first[1] then
				if r ~= 1 then
					pos["solid"][#pos["solid"]][3] = w.solid
					w.solid = 0
					first[1] = false
				end
			end
		end

		--We made it to another level of the map on the y coord. Time to reset/store again
		if first[1] then
			pos["solid"][#pos["solid"]][3] = w.solid
			w.solid = 0
			first[1] = false
		end
	end
	
	for index, value in pairs(pos) do
		for k = 1, #pos[index] do
			table.insert(objects["tile"], tile:new((pos[index][k][1] - 1) * 16, (pos[index][k][2] - 1) * 16, pos[index][k][3], pos[index][k][4], screen))
		end
	end
end