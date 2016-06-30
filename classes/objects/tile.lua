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
	
	self.speedx = 0
	self.speedy = 0

	self.quadi = id

	self.screen = screen
end

--temporary
function getID(id)
	if id == 19 then
		return 2
	elseif id == 20 then
		return 3
	else
		return false
	end
end

function tile:draw()
	if self.quadi == 1 then
		return
	end
	
	pushPop(self, true)
	love.graphics.setScreen(self.screen)

	for x = 1, self.width / 16 do
		love.graphics.draw(tileSet, tileQuads[self.quadi], self.x + (x - 1) * 16, self.y)
	end

	pushPop(self)
end