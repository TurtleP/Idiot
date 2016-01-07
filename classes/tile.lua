tile = class("tile")

function tile:init(x, y, width, height, screen)
	self.x = x
	self.y = y

	self.width = width
	self.height = height

	self.active = true
	
	self.speedx = 0
	self.speedy = 0

	self.quadi = 1

	self.screen = screen
end

function tile:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)

	for x = 1, self.width / 16 do
		love.graphics.draw(objectSet, objectQuads[self.quadi], self.x + (x - 1) * 16, self.y)
	end

	pushPop(self)
end