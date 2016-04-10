--[[
	Directional Pad Input

	Makes a D-Pad which is awesome
--]]

dinput = class("dinput")

local rotations =
{
	0,
	math.pi / 2,
	math.pi,
	math.pi * 3 / 2
}

function dinput:init(x, y, keys)
	dbuttonGraphic = love.graphics.newImage("mobile/dbutton.png")

	dpressedGraphic = love.graphics.newImage("mobile/dpressed.png")

	self.x = x
	self.y = y

	self.width = 80
	self.height = 80

	self.buttons = {}
	table.insert(self.buttons, dbutton:new(self.x + (self.width / 2) - 16, self.y, keys[1], 0))
	table.insert(self.buttons, dbutton:new(self.x + (self.width - 24), self.y + self.height / 2 - 8, keys[2], math.pi / 2))
	table.insert(self.buttons, dbutton:new(self.x + (self.width / 2) - 16, self.y + self.height - 16, keys[3], math.pi))
	table.insert(self.buttons, dbutton:new(self.x - 8, self.y + self.height / 2 - 8, keys[4], math.pi * 3 / 2))
end

function dinput:setID(id)
	self.id = id
end

function dinput:draw()
	love.graphics.setColor(255, 255, 255, 200)

	for k, v in ipairs(self.buttons) do
		v:draw()
	end

	love.graphics.setColor(58, 55, 55, 200)

	love.graphics.circle("fill", self.x + self.width / 2, self.y + self.height / 2, 16)

	love.graphics.setColor(255, 255, 255, 255)
end

function dinput:touchPressed(id, x, y, pressure)
	self:touchMoved(id, x, y, pressure)
end

function dinput:touchMoved(id, x, y, pressure)
	for k = 1, #self.buttons do
		local v  = self.buttons[k]

		if v:touchPressed(id, x, y, pressure) then
			v:setHeld(id, true)
		else
			v:setHeld(id, false)
		end
	end
end

function dinput:touchReleased(id, x, y, pressure)
	for k = 1, #self.buttons do
		local v  = self.buttons[k]

		if v.held then
			v:setHeld(id, false, true)
		end
	end
end

dbutton = class("dbutton")

function dbutton:init(x, y, button, rotation)
	self.x = x
	self.y = y

	local width, height = 32, 16
	if rotation == math.pi / 2 or rotation == math.pi * 3 / 2 then
		width, height = 16, 32
		self.sides = true
	end

	self.width = width
	self.height = height

	self.button = button

	self.rotation = rotation

	self.held = false
end

function dbutton:draw()
	local graphic = dbuttonGraphic
	if self.held then
		graphic = dpressedGraphic
	end
	love.graphics.draw(graphic, self.x, self.y, self.rotation)
end

function dbutton:touchPressed(id, x, y, pressure)
	local offsetX, offsetY = 0, 0
	if self.sides then
		offsetX, offsetY = self.width / 2, -8
	end

	return aabb(self.x + offsetX, self.y + offsetY, self.width, self.height, x / scale, y / scale, 8, 8)
end

function dbutton:setHeld(id, isHeld, isReleased)
	if isHeld then
		self.held = id
	elseif not isHeld then
		self.held = false
	end

	if self.held then
		if state ~= "title" or (state == "game" and not paused) then
			love.keypressed(self.button)
		end
	else
		if state ~= "title" or (state == "game" and not paused) then
			love.keyreleased(self.button)
		end
	end

	if isReleased then
		if state == "title" or (state == "game" and paused) then
			love.keypressed(self.button)
		end
	end
end