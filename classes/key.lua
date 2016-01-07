key = class("key")

function key:init(x, y, screen)
	self.x = x
	self.y = y
	self.width = 4
	self.height = 10

	self.mask = {}

	self.speedx = 0
	self.speedy = 0

	self.quadi = 1
	self.timer = 0

	self.screen = screen
end

function key:update(dt)
	self.timer = self.timer + 8 * dt
	self.quadi = math.floor(self.timer % 4) + 1
end

function key:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)

	love.graphics.draw(keyImage, keyQuads[self.quadi], self.x, self.y + math.sin(love.timer.getTime() * 8))

	pushPop(self)
end

function key:collect()
	keySound:play()
	self.remove = true
end