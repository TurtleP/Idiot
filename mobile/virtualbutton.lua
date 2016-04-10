--[[
	Virtual Button

	Makes it so there's buttons to tap
	Fancy stuff. Yeh.
--]]

virtualbutton = class("virtualbutton")

function virtualbutton:init(x, y, text, key, ...)
	self.x = x
	self.y = y
	self.text = text
	self.key = key

	self.width = 32
	self.height = 32

	self.options = {...}

	for _, v in pairs(self.options) do
		if v == "onRelease" then
			self.onRelease = true
		end
	end

	self.colors =
	{
		["true"] = {197, 200, 200, 200},
		["false"] = {58, 55, 55, 200}
	}

	self.pressed = false

	self.realX = x - 16
	self.realY = y - 16

	self.id = false
end

function virtualbutton:touchPressed(id, x, y, pressure)
	if state == "intro" then
		return
	end

	if aabb(self.x, self.y, self.width, self.height, x / scale, y / scale, 8, 8) then
		self.pressed = true
		
		self.id = id

		love.keypressed(self.key)
	end
end

function virtualbutton:touchReleased(id, x, y, pressure)
	if self.pressed then
		if self.id == id then
			if self.onRelease then
				love.keyreleased(self.key)
			end
			self.pressed = false
		end
	end
end

function virtualbutton:draw()
	if state == "intro" then
		return
	end

	love.graphics.setColor(self.colors[tostring(self.pressed)])

	love.graphics.circle("fill", self.x, self.y, 16)

	love.graphics.setColor(self.colors[tostring((not self.pressed))])

	love.graphics.print(self.text, self.realX + (self.width / 2) - signFont:getWidth(self.text) / 2 + 1, self.realY + (self.height / 2) - signFont:getHeight() / 2 + 2)

	love.graphics.setColor(255, 255, 255, 255)
end