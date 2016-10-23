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
require 'classes/objects/teleporter'
require 'classes/objects/spikes'
require 'classes/objects/pipe'
require 'classes/objects/hud'
require 'classes/objects/button'
require 'classes/objects/sensor'
require 'classes/objects/dropper'
require 'classes/objects/laser'
require 'classes/objects/notgate'
require 'classes/objects/delayer'
require 'classes/objects/andgate'
require 'classes/objects/lava'

_EMULATEHOMEBREW = (love.system.getOS() ~= "3ds")

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

	teleporterImage = love.graphics.newImage("graphics/objects/teleporter.png")
	teleporterQuads = {}
	for k = 1, 6 do
		teleporterQuads[k] = love.graphics.newQuad((k - 1) * 17, 0, 16, 32, teleporterImage:getWidth(), teleporterImage:getHeight())
	end

	pipeImage = love.graphics.newImage("graphics/objects/pipe.png")
	pipeQuads = {}
	for k = 1, 4 do
		pipeQuads[k] = love.graphics.newQuad((k - 1) * 17, 0, 16, 16, pipeImage:getWidth(), pipeImage:getHeight())
	end

	buttonImage = love.graphics.newImage("graphics/objects/button.png")
	buttonQuads = {}
	for k = 1, 2 do
		buttonQuads[k] = {}
		for y = 1, 2 do
			buttonQuads[k][y] = love.graphics.newQuad((k - 1) * 4, (y - 1) * 8, 3, 8, buttonImage:getWidth(), buttonImage:getHeight())
		end
	end

	dropperImage = love.graphics.newImage("graphics/objects/dropper.png")
	dropperQuads = {}
	for k = 1, 9 do
		dropperQuads[k] = love.graphics.newQuad((k - 1) * 17, 0, 16, 16, dropperImage:getWidth(), dropperImage:getHeight())
	end

	delayerImage = love.graphics.newImage("graphics/objects/delayer.png")
	delayerQuads = {}
	for y = 1, 4 do
		for x = 1, 5 do
			table.insert(delayerQuads, love.graphics.newQuad((x - 1) * 15, (y - 1) * 19, 15, 19, delayerImage:getWidth(), delayerImage:getHeight()))
		end
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

	notImage = love.graphics.newImage("graphics/objects/not.png")

	andImage = love.graphics.newImage("graphics/objects/and.png")

	introImage = love.graphics.newImage("graphics/intro/intro.png")
	potionImage = love.graphics.newImage("graphics/intro/potionLogo.png")
	
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
	for k = 1, 8 do
		mapScripts[k] = require("maps/script/" .. k)
	end

	maps = {}
	for k = 1, 12 do
		maps[k] = {map = require("maps/" .. k), top = love.graphics.newImage("graphics/maps/top/" .. k .. ".png"), bottom = nil}
	end
	maps[7].bottom = love.graphics.newImage("graphics/maps/bottom/7.png")
	maps[9].bottom = love.graphics.newImage("graphics/maps/bottom/9.png")
	
	jumpSound = love.audio.newSource("audio/jump.ogg", "static")
	scrollSound = love.audio.newSource("audio/blip.ogg", "static")
	keySound = love.audio.newSource("audio/key.ogg", "static")
	plateSound = love.audio.newSource("audio/plate.ogg", "static")
	deathSound = love.audio.newSource("audio/death.ogg", "static")
	unlockSound = love.audio.newSource("audio/unlock.ogg", "static")
	pipeSound = love.audio.newSource("audio/pipe.ogg", "static")
	buttonSound = love.audio.newSource("audio/button.ogg", "static")
	timeSound = love.audio.newSource("audio/time.ogg", "static")
	sensorSound = { love.audio.newSource("audio/sensoron.ogg", "static") , love.audio.newSource("audio/sensoroff.ogg", "static") }
	pauseSound = love.audio.newSource("audio/pause.ogg", "static")

	signFont = love.graphics.newFont("graphics/PressStart2P.ttf", 8)
	endFont = love.graphics.newFont("graphics/PressStart2P.ttf", 16)

	--enableAudio = false
	love.audio.setVolume(0)

	mapScrollY = 0

	buildVersion = "1.0-dev"

	--[[BACKGROUNDLAYER = 1.5
	NORMALLAYER = 0
	ENTITYLAYER = -1.5
	INTERFACELAYER = -3

	love.graphics.set3D(true)]]

	savePath = "sdmc:/LovePotion/Idiot/"

	--loadSettings()

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

	love.graphics.setScreen("top")
	shadowPrint(love.timer.getFPS(), 0, 6)
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
	love.filesystem.write(savePath .. "save.txt", "0x" .. tonumber(currentLevel, 16))
end

function loadSavedGame()
	if pcall(love.filesystem.read, "save.txt") then

		local data = love.filesystem.read("save.txt")

		if not data then
			return
		end

		currentLevel = tonumber(love.filesystem.read("save.txt"):gsub("0x", ""), 10)

		if not currentLevel then
			return
		end
	end

	gameFunctions.changeState("game", currentLevel)
end

function saveSettings()
	local data = tostring(directionalPadEnabled) .. ";" .. controls["jump"] .. ";" .. controls["use"] .. ";"

	love.filesystem.write(savePath .. "options.txt", data)
end

function deleteData()
	love.filesystem.remove("options.txt")

	love.filesystem.remove("save.txt")

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
	local succ = pcall(love.filesystem.read, savePath .. "options.txt")

	if succ then
		local data = love.filesystem.read(savePath .. "options.txt")

		if data then
			local split = data:split(";")

			if #split ~= 3 then
				love.filesystem.remove(savePath .. "options.txt")

				defaultSettings()
			end

			toggleDPad(bool(split[1]))

			controls["jump"] = split[2]

			controls["use"] = split[3]
		end
	end
end

function toggleDPad(set)
	local enable = not directionalPadEnabled
	if set ~= nil then
		enable = set
	end

	directionalPadEnabled = enable

	if directionalPadEnabled then
		controls["up"] = "dup"
		controls["down"] = "ddown"
		controls["left"] = "dleft"
		controls["right"] = "dright"
	else
		controls["right"] = "cpadright"
		controls["left"] = "cpadleft"
		controls["up"] = "cpadup"
		controls["down"] = "cpaddown"
	end
end