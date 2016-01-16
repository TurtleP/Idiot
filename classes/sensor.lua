sensor = class("sensor")

function sensor:init(x, y, r, screen)
	self.x = x
	self.y = y

	self.width = 16
	self.height = 16

	self.passive = true

	self.particleTimer = 0
	self.particles = {}

	local temp
	for k = 1, 20 do
		temp = sensorparticle:new(love.math.random(self.x + 2, self.x + self.width - 2), love.math.random(self.y, self.y + self.height), love.math.random(10, 20), self.y + self.height, screen)
		table.insert(objects["sensor"], temp)
		table.insert(self.particles, temp)
	end

	self.link = r.link
	self.direction = r.direction or "ver"
	print(r.direction, self.direction)

	self.start = {false, false}

	self.outtable = {}

	self.screen = screen
end

function sensor:addOut(obj)
	table.insert(self.outtable, obj)
end

function sensor:update(dt)
	self.particleTimer = self.particleTimer + dt
	if self.particleTimer > 0.3 then
		self.particleTimer = 0
	end

	if self.direction == "ver" then
		local leftTrigger = checkrectangle(self.x + 2, self.y, 1, self.height, {"player"}, self)
		local rightTrigger = checkrectangle(self.x + self.width - 2, self.y, 1, self.height, {"player"}, self)

		if #leftTrigger > 0 then
			if leftTrigger[1][2].speedx > 0 then
				if not self.start[1] and not self.start[2] then
					self.start[1] = true
					self:activate()
				end
			else
				if self.start[2] then
					self.start[2] = false
					sensorSound[2]:play()
					for k, v in pairs(self.particles) do
						v:resetToggle()
					end
				end
			end
		elseif #rightTrigger > 0 then
			if rightTrigger[1][2].speedx < 0 then
				if not self.start[1] and not self.start[2] then
					self.start[2] = true
					self:activate()
				end
			else
				if self.start[1] then
					self.start[1] = false
					sensorSound[2]:play()
					for k, v in pairs(self.particles) do
						v:resetToggle()
					end
				end
			end
		end
	else
		local upTrigger = checkrectangle(self.x, self.y, self.width, 1, {"player"}, self)
		local downTrigger = checkrectangle(self.x, self.y + self.height, self.width, 1, {"player"}, self)

		if #upTrigger > 0 then
			if upTrigger[1][2].speedy > 0 then
				if not self.start[1] and not self.start[2] then
					self.start[1] = true
					self:activate()
				end
			else
				if self.start[1] then
					self.start[1] = false
					sensorSound[2]:play()
					for k, v in pairs(self.particles) do
						v:resetToggle()
					end
				end
			end
		elseif #downTrigger > 0 then
			if downTrigger[1][2].speedy < 0 then
				if not self.start[1] and not self.start[2] then
					self.start[2] = true
					self:activate()
				end
			else
				if self.start[2] then
					self.start[2] = false
					sensorSound[2]:play()
					for k, v in pairs(self.particles) do
						v:resetToggle()
					end
				end
			end
		end
	end
end

function sensor:activate()
	for k, v in pairs(self.particles) do
		v:setColor()
	end

	for j = 1, #self.outtable do
		self.outtable[j]:input("toggle")
	end

	if self.start[1] or self.start[2] then
		sensorSound[1]:play()
	end
end

sensorparticle = class("sensorparticle")

function sensorparticle:init(x, y, speed, max, screen)
	self.x = x

	self.y = y
	self.originY = y

	self.speedx = 0
	self.speedy = speed

	self.max = max

	self.passive = true

	self.width = 1
	self.height = 1

	self.color = {255, 116, 0, 200}

	self.colors =
	{
		["true"] = {0, 220, 92, 200},
		["false"] = {255, 116, 0, 200}
	}

	self.toggle = false
	self.canToggle = true

	self.screen = screen
end

function sensorparticle:setColor(color)
	if self.canToggle then
		self.color = self.colors[tostring(not self.toggle)]
		self.toggle = not self.toggle
		self.canToggle = false
	end
end

function sensorparticle:resetToggle()
	self.canToggle = true
end

function sensorparticle:update(dt)
	self.y = self.y + self.speedy * dt
	if self.y > self.max then
		self.y = self.originY - self.height
	end
end

function sensorparticle:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)

	love.graphics.setColor(unpack(self.color))
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor(255, 255, 255, 255)

	pushPop(self)
end