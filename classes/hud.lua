HUD = class("HUD")

function HUD:init()
	self.x = 0
	self.y = gameFunctions.getHeight() - 16

	self.width = 28
	self.height = 16

	self.keytimer = 0
	self.keyi = 1
end

function HUD:update(dt)
	self.keytimer = self.keytimer + 8 * dt
	self.keyi = math.floor(self.keytimer % 4) + 1
end

function HUD:draw()
	local v = "top"
	if objects["player"][1] and objects["player"][1].screen then
		v = objects["player"][1].screen
	end

	love.graphics.setScreen(v)

	love.graphics.setFont(signFont)
	local keys = 0
	if objects["player"][1] and objects["player"][1].keys then
		keys = objects["player"][1].keys
	end
	love.graphics.setColor(64, 64, 64, 200)
	love.graphics.rectangle("fill", self.x, self.y, 12 + signFont:getWidth(":" .. keys), self.height)
	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.draw(keyImage, keyQuads[self.keyi], self.x + 2, (self.y + (self.height / 2) - 5) + math.sin(love.timer.getTime() * 8))
	love.graphics.print(":" .. keys, self.x + 10, self.y + 2 + (self.height / 2) - signFont:getHeight() / 2)
end