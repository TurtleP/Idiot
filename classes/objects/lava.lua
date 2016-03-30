lava = class("lava")

function lava:init(x, y, width, screen)
	self.active = true
	self.static = true

	self.x = x
	self.y = y

	self.width = width
	self.height = 8

	self.quadi = 1
	self.timer = 0

	self.screen = screen
end

function lava:update(dt)
	self.timer = self.timer + 4 * dt
	self.quadi = math.floor(self.timer % #lavaQuads) + 1
end

function lava:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)

	for x = 1, self.width / 16 do
		love.graphics.draw(lavaImage, lavaQuads[self.quadi], self.x + (x - 1) * 16, self.y)
	end

	pushPop(self)
end