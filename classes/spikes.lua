spikes = class("spikes")

function spikes:init(x, y, screen)
	self.x = x
	self.y = y

	self.width = 16
	self.height = 8

	self.screen = screen
end

function spikes:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)

	love.graphics.draw(objectSet, objectQuads[10], self.x, self.y - 8)

	pushPop(self)
end