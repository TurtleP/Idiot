io.stdout:setvbuf("no")

--variables
require 'data'

--libraries
class = require 'libraries/middleclass'
require 'libraries/physics'
require 'libraries/event'
require 'libraries/gamefunctions'

--states
require 'states/title'
require 'states/game'
require 'states/intro'

--characters
require 'classes/characters/player'
require 'classes/characters/ren'
require 'classes/characters/turret'
require 'classes/characters/turtle'

--pause menu (forever alone!)
require 'classes/misc/pausemenu'

--objects
require 'classes/objects/tile'
require 'classes/objects/sign'
require 'classes/objects/box'
require 'classes/objects/key'
require 'classes/objects/pressureplate'
require 'classes/objects/fan'
require 'classes/objects/door'
require 'classes/objects/spikes'
require 'classes/objects/pipe'
require 'classes/objects/hud'
require 'classes/objects/sensor'
require 'classes/objects/laser'
require 'classes/objects/notgate'
require 'classes/objects/andgate'
require 'classes/objects/lava'
require 'classes/objects/bomb'

_EMULATEHOMEBREW = (love.system.getOS() ~= "3ds")

--[[
	1: ESCAPE
	2: EASY KEY

	3: BOX N PLATE INTRO
	4: THINK OUTSIDE THE BOX
	5: FAN INTRO
	6: DUAL FANS
	
	7: VS TURRET
	
	8: FAN GAP
	9: PIPE N KEY
	10: PLATFORM BOX
	11: REPLICA
	
	12: VS GABE
	
	13: SENSOR
	14: SPIKE PIT
	15: LAVA PIT
	16: LAVA PIT 2

	17: VS TURTLE
--]]

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")

	idiotImage = love.graphics.newImage("graphics/player/idiot.png")
	idiotQuads = {}
	for k = 1, 9 do
		idiotQuads[k] = {}
		for y = 1, 2 do
			idiotQuads[k][y] = love.graphics.newQuad((k - 1) * 16, (y - 1) * 18, 16, 18, idiotImage:getWidth(), idiotImage:getHeight())
		end
	end

	idiotHatImage = love.graphics.newImage("graphics/player/hat.png")
	idiotDeadImage = love.graphics.newImage("graphics/player/dead.png")

	dialogs = 
	{
		["idiot"] = love.graphics.newImage("graphics/dialog/idiot.png"),
		["ren"] = love.graphics.newImage("graphics/dialog/ren.png"),
		["turtle"] = love.graphics.newImage("graphics/dialog/turtle.png"),
		["turret"] = love.graphics.newImage("graphics/dialog/turret.png")
	}

	objectSet = love.graphics.newImage("graphics/objects.png")
	objectQuads = {}
	for k = 1, objectSet:getWidth() / 17 do
		objectQuads[k] = love.graphics.newQuad((k - 1) * 17, 0, 16, 16, objectSet:getWidth(), objectSet:getHeight())
	end

	tileSet = love.graphics.newImage("graphics/tiles.png")
	tileQuads = {}
	for k = 1, tileSet:getWidth() / 17 do
		tileQuads[k] = love.graphics.newQuad((k - 1) * 17, 0, 16, 16, tileSet:getWidth(), tileSet:getHeight())
	end

	scrollArrow = love.graphics.newImage("graphics/scroll.png")
	
	keyImage = love.graphics.newImage("graphics/objects/key.png")
	keyNormalImage = love.graphics.newImage("graphics/objects/keyDropped.png")
	keyQuads = {}
	for k = 1, 4 do
		keyQuads[k] = love.graphics.newQuad((k - 1) * 5, 0, 4, 10, keyImage:getWidth(), keyImage:getHeight())
	end

	plateImage = love.graphics.newImage("graphics/objects/pressureplate.png")
	plateQuads = {}
	for k = 1, 2 do
		plateQuads[k] = love.graphics.newQuad((k - 1) * 21, 0, 21, 5, plateImage:getWidth(), plateImage:getHeight())
	end

	fanImage = love.graphics.newImage("graphics/objects/fan.png")
	fanQuads = {}
	for k = 1, 4 do
		fanQuads[k] = love.graphics.newQuad((k - 1) * 17, 0, 16, 16, fanImage:getWidth(), fanImage:getHeight())
	end

	doorImage = love.graphics.newImage("graphics/objects/door.png")
	doorQuads = {}
	for k = 1, 3 do
		doorQuads[k] = {}
		for y = 1, 2 do
			doorQuads[k][y] = love.graphics.newQuad((k - 1) * 17, (y - 1) * 32, 16, 32, doorImage:getWidth(), doorImage:getHeight())
		end
	end

	pipeImage = love.graphics.newImage("graphics/objects/pipe.png")
	pipeQuads = {}
	for k = 1, 4 do
		pipeQuads[k] = love.graphics.newQuad((k - 1) * 17, 0, 16, 16, pipeImage:getWidth(), pipeImage:getHeight())
	end

	dropperImage = love.graphics.newImage("graphics/objects/dropper.png")
	dropperQuads = {}
	for k = 1, 9 do
		dropperQuads[k] = love.graphics.newQuad((k - 1) * 17, 0, 16, 16, dropperImage:getWidth(), dropperImage:getHeight())
	end

	backgroundImage = { top = love.graphics.newImage("graphics/game/background.png") , bottom = love.graphics.newImage("graphics/game/background2.png") }

	renImage = love.graphics.newImage("graphics/enemy/ren.png")
	renQuads = {}
	for k = 1, 6 do
		renQuads[k] = {}
		for y = 1, 2 do
			renQuads[k][y] = love.graphics.newQuad((k - 1) * 15, (y - 1) * 13, 15, 13, renImage:getWidth(), renImage:getHeight())
		end
	end

	turretImage = love.graphics.newImage("graphics/enemy/turret.png")
	turretQuads = {}
	for x = 1, 5 do
		turretQuads[x] = {}
		for y = 1, 2 do
			turretQuads[x][y] = love.graphics.newQuad((x - 1) * 13, (y - 1) * 14, 13, 14, turretImage:getWidth(), turretImage:getHeight())
		end
	end

	lavaImage = love.graphics.newImage("graphics/objects/lava.png")
	lavaQuads = {}
	for k = 1, 4 do
		lavaQuads[k] = love.graphics.newQuad((k - 1) * 17, 0, 16, 8, lavaImage:getWidth(), lavaImage:getHeight())
	end

	titleImage = love.graphics.newImage("maps/title.png")
	optionsImage = love.graphics.newImage("maps/options.png")
	titleLogo = love.graphics.newImage("graphics/title/logo.png")

	introImage = love.graphics.newImage("graphics/intro/intro.png")
	potionImage = love.graphics.newImage("graphics/intro/potionLogo.png")
	
	blocksGraphic = love.graphics.newImage("graphics/objects/blocks.png")
	blocksQuads = {}
	for k = 1, 6 do
		blocksQuads[k] = love.graphics.newQuad((k - 1) * 8, 0, 8, 8, blocksGraphic:getWidth(), blocksGraphic:getHeight())
	end

	turtleImage = love.graphics.newImage("graphics/enemy/turtle.png")
	turtleQuads = {}
	for y = 1, 3 do
		for x = 1, 4 do
			table.insert(turtleQuads, love.graphics.newQuad((x - 1) * 12, (y - 1) * 21, 12, 20, turtleImage:getWidth(), turtleImage:getHeight()))
		end
	end

	turtleBossImage = love.graphics.newImage("graphics/enemy/turtleboss.png")
	turtleBossQuads = {}
	for x = 1, 10 do
		turtleBossQuads[x] = love.graphics.newQuad((x - 1) * 32, 0, 32, 32, turtleBossImage:getWidth(), turtleBossImage:getHeight())
	end

	bombImage = love.graphics.newImage("graphics/enemy/bomb.png")
	bombQuads = {}
	for x = 1, 3 do
		bombQuads[x] = love.graphics.newQuad((x - 1) * 12, 0, 12, 12, bombImage:getWidth(), bombImage:getHeight())
	end

	explosionImage = love.graphics.newImage("graphics/enemy/explosion.png")
	explosionQuads = {}
	for k = 1, 7 do
		explosionQuads[k] = love.graphics.newQuad((k - 1) * 18, 0, 16, 16, explosionImage:getWidth(), explosionImage:getHeight())
	end

	controls =
	{
		["right"] = "cpadright",
		["left"] = "cpadleft",
		["up"] = "cpadup",
		["down"] = "cpaddown",
		["jump"] = "a",
		["use"] = "b",
		["pause"] = "start"
	}

	mapScripts = {}
	for k = 1, 13 do
		mapScripts[k] = require("maps/script/" .. k)
	end

	maps = {}
	for k = 1, 18 do
		maps[k] = {map = require("maps/" .. k), top = love.graphics.newImage("maps/top/" .. k .. ".png"), bottom = nil}

		if love.filesystem.isFile("maps/bottom/" .. k .. ".png") then
			maps[k].bottom = love.graphics.newImage("maps/bottom/" .. k .. ".png")
		end
	end
	
	jumpSound = love.audio.newSource("audio/jump.ogg", "static")
	scrollSound = love.audio.newSource("audio/blip.ogg", "static")
	keySound = love.audio.newSource("audio/key.ogg", "static")
	plateSound = love.audio.newSource("audio/plate.ogg", "static")
	deathSound = love.audio.newSource("audio/death.ogg", "static")
	unlockSound = love.audio.newSource("audio/unlock.ogg", "static")
	pipeSound = love.audio.newSource("audio/pipe.ogg", "static")
	sensorSound = { love.audio.newSource("audio/sensoron.ogg", "static") , love.audio.newSource("audio/sensoroff.ogg", "static") }
	pauseSound = love.audio.newSource("audio/pause.ogg", "static")
	blockPickupSound = love.audio.newSource("audio/pickup.ogg")
	blockThrowSound = love.audio.newSource("audio/throw.ogg")
	explosionSound = love.audio.newSource("audio/explode.ogg")

	hitSounds = {}
	for k = 1, 3 do
		hitSounds[k] = love.audio.newSource("audio/hurt" .. k .. ".ogg")
	end

	signFont = love.graphics.newFont("graphics/PressStart2P.ttf", 8)
	endFont = love.graphics.newFont("graphics/PressStart2P.ttf", 16)

	--enableAudio = false
	--love.audio.setVolume(0)

	mapScrollY = 0

	buildVersion = "v1.0"

	savePath = "sdmc:/LovePotion/Idiot/"

	loadSettings()

	gameFunctions.changeState("intro")
end

function love.update(dt)
	dt = math.min(1/60, dt)

	if state then
		if _G[state .. "Update"] then
			_G[state .. "Update"](dt)
		end
	end
	
	if _EMULATEHOMEBREW then
		if state == "game" then
			if objects["player"][1] then
				local v = objects["player"][1]

				if v.screen == "bottom" then
					mapScrollY = math.min(mapScrollY + 480 * dt, 240)
				else
					mapScrollY = math.max(mapScrollY - 480 * dt, 0)
				end
			end
		else
			if state == "title" then
				if titleState == "main" then
					mapScrollY = math.max(mapScrollY - 480 * dt, 0)
				elseif titleState == "options" then
					mapScrollY = math.min(mapScrollY + 480 * dt, 240)
				end
			end
		end
	end
end

function love.draw()
	love.graphics.push()

	love.graphics.scale(scale, scale)

	if state then
		if _G[state .. "Draw"] then
			_G[state .. "Draw"]()
		end
	end

	love.graphics.pop()
end

function love.keypressed(key)
	if not state then
		return
	end

	if _G[state .. "Keypressed"] then
		_G[state .. "Keypressed"](key)
	end
end

function love.keyreleased(key)
	if not state then
		return
	end

	if _G[state .. "Keyreleased"] then
		_G[state .. "Keyreleased"](key)
	end
end

require 'libraries/3ds'

--[[ GAME FUNCTIONS ]]--
gameFunctions = {}

function gameFunctions.changeState(toState, ...)
	local arg = {...}

	if _G[toState .. "Init"] then
		_G[toState .. "Init"](unpack(arg))
		
		state = toState
	end
end

function gameFunctions.getWidth(screen)
	if love.graphics.getScreen() == "bottom" then
		return 320
	end
	return 400
end

function gameFunctions.getHeight()
	return 240
end

function bool(string)
	return string == "true"
end

function saveGame()
	if love.filesystem.isFile(savePath .. "save.txt") then
		os.remove(savePath .. "save.txt")
	end

	local file = love.filesystem.newFile(savePath .. "save.txt")

	file:open("w")
	file:write(currentLevel)
	file:close()
end

function loadSavedGame()
	if love.filesystem.isFile(savePath .. "save.txt") then

		local data = love.filesystem.read(savePath .. "save.txt")

		if not data then
			return
		end

		currentLevel = tonumber(love.filesystem.read("save.txt"))

		if not currentLevel then
			return
		end

		gameFunctions.changeState("game", currentLevel)
	end
end

function saveSettings()
	if love.filesystem.isFile(savePath .. "options.txt") then
		os.remove(savePath .. "options.txt")
	end

	local data = tostring(directionalPadEnabled) .. ";" .. controls["jump"] .. ";" .. controls["use"] .. ";"

	file = love.filesystem.newFile(savePath .. "options.txt")

	file:open("w")
	file:write(data)
	file:close()
end

--[[if not _EMULATEHOMEBREW then
	function love.filesystem.remove(file)
		os.remove(savePath .. file)
	end
end]]

function deleteData()
	os.remove(savePath .. "options.txt")

	os.remove(savePath .. "save.txt")

	defaultSettings()
end

function defaultSettings()
	toggleDPad(false)

	controls =
	{
		["right"] = "cpadright",
		["left"] = "cpadleft",
		["up"] = "cpadup",
		["down"] = "cpaddown",
		["jump"] = "a",
		["use"] = "b",
		["pause"] = "start"
	}

	if titleOptions then
		titleOptions[1] =
		{"New Game", 
			function()
				gameFunctions.changeState("game") 
			end
		}
	end
end

function loadSettings()
	if love.filesystem.isFile(savePath .. "options.txt") then
		local data = love.filesystem.read(savePath .. "options.txt")

		if data then
			local split = data:split(";")

			if #split ~= 3 then
				os.remove(savePath .. "options.txt")

				defaultSettings()
				
				return
			end

			toggleDPad(bool(split[1]))

			controls["jump"] = split[2]

			controls["use"] = split[3]
		end
	else
		defaultSettings()
	end
end

function toggleDPad(set)
	local enable = not directionalPadEnabled
	if set ~= nil then
		enable = set
	end

	directionalPadEnabled = enable

	if directionalPadEnabled then
		controls["up"] = "up"
		controls["down"] = "down"
		controls["left"] = "left"
		controls["right"] = "right"
	else
		controls["right"] = "cpadright"
		controls["left"] = "cpadleft"
		controls["up"] = "cpadup"
		controls["down"] = "cpaddown"
	end
end