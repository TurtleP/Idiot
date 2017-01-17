tile = class("tile")

function tile:init(x, y, width, height, screen, id)
	self.x = x
	self.y = y

	self.width = width
	self.height = height
	
	self.active = true

	if id > 1 then
		self.passive = true
	end

	self.category = 1
	
	self.speedx = 0
	self.speedy = 0

	self.screen = screen
end