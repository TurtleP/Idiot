box = class("box")

function box:init(x, y, link, screen)
	self.x = x
	self.y = y

	self.width = 16
	self.height = 16

	self.active = true

	self.speedx = 0
	self.speedy = 0

	self.gravity = 300
	self.oldGravity = self.gravity

	self.mask =
	{
		["tile"] = true,
		["spikes"] = true,
		["box"] = true,
		["pipe"] = true,
		["fan"] = true,
		["player"] = true
	}

	self.passive = false
	self.friction = 6

	self.useRectangle = gameAddUseRectangle(self.x, self.y, self.width, self.height, self)

	self.screen = screen
end

function box:use(player)
	self.parent = player

	local active = true
	if player then
		active = false
	end
	self.passive = not active

	return self
end

function box:update(dt)
	if self.parent then
		return
	end

	self.useRectangle.x = self.x
	self.useRectangle.y = self.y
end

function box:draw()
	pushPop(self, true)

	love.graphics.setScreen(self.screen)
	love.graphics.draw(objectSet, objectQuads[4], self.x, self.y)

	pushPop(self)
end

--BEWARE
function newBoxGhost(x, y)
	local box = {}

	box.x = x
	box.y = y

	box.width = 16
	box.height = 16

	box.mask = {}
	box.active = false
	box.passive = true

	box.fade = 1

	function box:update(dt)
		self.fade = math.max(self.fade - 0.6 * dt, 0)
		if self.fade == 0 then
			self.remove = true
		end
	end

	function box:draw()
		love.graphics.setColor(255, 0, 0, 255 * self.fade)
		love.graphics.draw(objectSet, objectQuads[4], self.x, self.y)
		love.graphics.setColor(255, 255, 255, 255)
	end

	return box
end