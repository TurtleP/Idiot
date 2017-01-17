spikes = class("spikes")

function spikes:init(x, y, width, screen)
	self.x = x
	self.y = y

	self.category = 9
	
	self.active = true
	self.static = true
	
	self.width = width
	self.height = 8

	self.screen = screen
end

function spikes:draw()
	love.graphics.setScreen(self.screen)

	for x = 1, self.width / 16 do
		love.graphics.draw(objectSet, objectQuads[10], self.x + (x - 1) * 16, self.y - 8)
	end
end