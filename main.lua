io.stdout:setvbuf("no")

--misc
require 'data'

--libraries
class = require 'libraries/middleclass'
require 'libraries/physics'
require 'libraries/event'
require 'libraries/gamefunctions'

--states
require 'states/title'
require 'states/game'

--entities/objects
require 'classes/player'
require 'classes/ren'

require 'classes/pausemenu'

require 'classes/tile'
require 'classes/sign'
require 'classes/box'
require 'classes/key'
require 'classes/pressureplate'
require 'classes/fan'
require 'classes/door'
require 'classes/teleporter'
require 'classes/spikes'
require 'classes/pipe'
require 'classes/hud'
require 'classes/button'
require 'classes/sensor'
require 'classes/dropper'
require 'classes/laser'
require 'classes/notgate'
require 'classes/delayer'
require 'classes/andgate'

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
	for k = 1, 2 do
		delayerQuads[k] = love.graphics.newQuad((k - 1) * 16, 0, 16, 16, delayerImage:getWidth(), delayerImage:getHeight())
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

	titleImage = love.graphics.newImage("maps/title.png")
	optionsImage = love.graphics.newImage("maps/options.png")

	notImage = love.graphics.newImage("graphics/objects/not.png")

	andImage = love.graphics.newImage("graphics/objects/and.png")

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
	for k = 1, 4 do
		mapScripts[k] = require("maps/script/" .. k)
	end

	backgroundMusic = love.audio.newSource("audio/bgm.wav", "stream")

	titleMusic = love.audio.newSource("audio/title.wav", "stream")

	jumpSound = love.audio.newSource("audio/jump.wav", "static")
	scrollSound = love.audio.newSource("audio/blip.wav", "static")
	keySound = love.audio.newSource("audio/key.wav", "static")
	plateSound = love.audio.newSource("audio/plate.wav", "static")
	teleportSound = love.audio.newSource("audio/teleport.wav", "static")
	deathSound = love.audio.newSource("audio/death.wav", "static")
	unlockSound = love.audio.newSource("audio/unlock.wav", "static")
	pipeSound = love.audio.newSource("audio/pipe.wav", "static")
	buttonSound = love.audio.newSource("audio/button.wav", "static")
	timeSound = love.audio.newSource("audio/time.wav", "static")
	sensorSound = { love.audio.newSource("audio/sensoron.wav", "static") , love.audio.newSource("audio/sensoroff.wav", "static") }
	pauseSound = love.audio.newSource("audio/pause.wav", "static")

	signFont = love.graphics.newFont("graphics/PressStart2P.ttf", 8)
	endFont = love.graphics.newFont("graphics/PressStart2P.ttf", 32)

	local mobileDevice =
	{
		["Android"] = true,
		["iOS"] = true
	}
	
	if mobileDevice[love.system.getOS()] then
		local w, h = love.graphics.getDimensions()
		scale = math.floor(math.max(w / 400, h / 240))

		buttonFont = love.graphics.newFont("graphics/PressStart2P.ttf", 8)

		require 'mobile/touchcontrol'

		touchControls = touchcontrol:new()

		--love.window.setMode(love.window.getDesktopDimensions())
	end

	enableAudio = false
	love.audio.setVolume(0)

	buildVersion = "1.0-dev"

	loadSettings()

	gameFunctions.changeState("title")
end

function love.update(dt)
	dt = math.min(1/60, dt)

	if _G[state .. "Update"] then
		_G[state .. "Update"](dt)
	end
end

function love.draw()
	love.graphics.push()

	love.graphics.scale(scale, scale)

	if _G[state .. "Draw"] then
		_G[state .. "Draw"]()
	end

	love.graphics.setFont(signFont)
	love.graphics.setScreen('top')
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("FPS: " .. love.timer.getFPS(), love.graphics.getWidth() - signFont:getWidth("FPS: " .. love.timer.getFPS()) - 3, gameFunctions.getHeight() - signFont:getHeight("FPS: " .. love.timer.getFPS() - 1))
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("FPS: " .. love.timer.getFPS(), love.graphics.getWidth() - signFont:getWidth("FPS: " .. love.timer.getFPS()) - 2, gameFunctions.getHeight() - signFont:getHeight("FPS: " .. love.timer.getFPS()))

	love.graphics.pop()
end

function love.keypressed(key)
	if _G[state .. "Keypressed"] then
		_G[state .. "Keypressed"](key)
	end

	if key == controls["debug"] then
		physdebug = not physdebug
	end
end

function love.keyreleased(key)
	if _G[state .. "Keyreleased"] then
		_G[state .. "Keyreleased"](key)
	end
end

require 'libraries/3ds'

--[[ GAME FUNCTIONS ]]--
gameFunctions = {}

function gameFunctions.changeState(toState, ...)
	state = toState

	local arg = {...}

	if _G[state .. "Init"] then
		_G[state .. "Init"](unpack(arg))
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
	love.filesystem.write("save.txt", "0x" .. tonumber(currentLevel, 16))
end

function loadGame()
	currentLevel = tonumber(love.filesystem.read("save.txt"):gsub("0x", ""), 10)

	print("Loading from file: " .. currentLevel)

	gameFunctions.changeState("game", currentLevel)
end

function saveSettings()
	local data = tostring(directionalPadEnabled) .. ";" .. controls["jump"] .. ";" .. controls["use"] .. ";"

	love.filesystem.write("options.txt", data)
end

function deleteData()
	love.filesystem.remove("options.txt")

	love.filesystem.remove("save.txt")

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
end

function loadSettings()
	if love.filesystem.isFile("options.txt") then
		local data = love.filesystem.read("options.txt")

		local split = data:split(";")

		toggleDPad(bool(split[1]))

		controls["jump"] = split[2]

		controls["use"] = split[3]

		print(unpack(split))
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