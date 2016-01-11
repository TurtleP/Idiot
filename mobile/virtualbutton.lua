--[[
	Virtual Button

	Makes it so there's buttons to tap
	Fancy stuff. Yeh.
--]]

virtualbutton = class("virtualbutton")

virtualButton = love.graphics.newImage("mobile/virtualbutton.png")
virtualButtonQuads = {}

for k = 1, 2 do
	virtualButtonQuads[k] = love.graphics.newQuad((k - 1) * 41, 0, 40, 40, virtualButton:getWidth(), virtualButton:getHeight())
end

function virtualbutton:init(x, y, text, key, backKey, gameOnly, releaseOnUntouch)
	self.x = x
	self.y = y
	self.text = text
	self.key = key
	self.r = r

	self.backKeyData = backKey

	self.releaseOnUntouch = releaseOnUntouch

	self.width = 40
	self.height = 40

	self.gameOnly = gameOnly

	self.colors =
	{
		["true"] = {quadi = 2, color = {255, 255, 255, 200}},
		["false"] = {quadi = 1, color = {42, 42, 42, 200}}
	}

	self.pressed = false

	self.id = 0
end

function virtualbutton:setPos(x, y)
	self.x, self.y = x, y
	self.boundsX = x - self.r
	self.boundsY = y - self.r
end

function virtualbutton:touchPressed(id, x, y, pressure)
	if self.gameOnly and state ~= "game" then
		return
	end

	if aabb(self.x, self.y, self.width, self.height, x / scale, y / scale, 8, 8) then
		self.pressed = true
		self.id = id

		if self.backKeyData and not self.key then
			love.keypressed(self.backKeyData)
		elseif self.key and not self.backKeyData then
			love.keypressed(self.key)
		elseif self.key and self.backKeyData then
			if state ~= "game" or (state == "game" and paused) then
				love.keypressed(self.backKeyData)
			else
				love.keypressed(self.key)
			end
		end
	end
end

function virtualbutton:touchReleased(id, x, y, pressure)
	if self.gameOnly and state ~= "game" then
		return
	end

	if self.pressed then
		if self.id == id then
			if self.releaseOnUntouch then
				love.keyreleased(self.key)
			end
			self.pressed = false
		end
	end
end

function virtualbutton:draw()
	if self.gameOnly and state ~= "game" then
		return
	end

	love.graphics.setFont(buttonFont)

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(virtualButton, virtualButtonQuads[self.colors[tostring(self.pressed)].quadi], self.x, self.y)

	love.graphics.setColor(unpack(self.colors[tostring(self.pressed)].color))
	love.graphics.circle("line", self.x + self.width / 2, self.y + self.height / 2, math.floor(self.width / 2), 64)

	love.graphics.setColor(unpack(self.colors[tostring(not self.pressed)].color))
	love.graphics.print(self.text, self.x + (self.width / 2) - buttonFont:getWidth(self.text) / 2 + 0.5, self.y + (self.height / 2) - buttonFont:getHeight(self.text) / 2 + 1.5)

	love.graphics.setColor(255, 255, 255, 255)
	
	love.graphics.setFont(signFont)
end