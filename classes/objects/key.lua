key = class("key")

function key:init(x, y, screen)
	self.x = x
	self.y = y
	self.width = 4
	self.height = 10

	self.category = 7
	
	self.mask = 
	{
		true
	}

	self.active = true
	self.passive = true

	self.speedx = 0
	self.speedy = 0

	self.quadi = 1
	self.timer = 0

	self.gravity = 0

	self.screen = screen

	self.rotation = 0
end

function key:update(dt)
	self.timer = self.timer + 8 * dt
	self.quadi = math.floor(self.timer % 4) + 1

	if self.active and not self.passive then
		if self.timer < 8 then
			self.rotation = self.rotation + 8 * dt
		else
			self.speedx = 0
			self.speedy = 0
		end
	end
end

function key:drop()
	self.active = true
	self.passive = false

	self.gravity = 400
	self.speedx = -20
end

function key:downCollide(name, data)
	if name == "tile" then
		if self.timer < 8 then
			self.speedy = -math.floor(self.speedy * 0.6)

			return false
		end
	end
end

function key:draw()
	love.graphics.setScreen(self.screen)

	if self.passive then
		love.graphics.draw(keyImage, keyQuads[self.quadi], self.x, self.y + math.sin(love.timer.getTime() * 8))
	else
		love.graphics.draw(keyNormalImage, self.x, self.y, self.rotation)
	end
end

function key:collect(player)
	keySound:play()
	player.keys = player.keys + 1
	self.remove = true
end