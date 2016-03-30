turret = class("turret")

function turret:init(x, y, screen)
	self.x = x
	self.y = y

	self.width = 13
	self.height = 14

	self.active = true

	self.gravity = 300

	self.speedx = 0
	self.speedy = 0

	self.mask =
	{
		["tile"] = true
	}

	self.quadi = 1
	self.scale = 1

	self.screen = screen
end

function turret:update(dt)

end

function turret:animate(dt)

end

function turret:faceDirection(dir)
	self.scale = dir
end

function turret:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)

	love.graphics.draw(turretImage, turretQuads[self.quadi][self.scale], self.x, self.y)

	pushPop()
end