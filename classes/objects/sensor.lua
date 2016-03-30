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
		temp = sensorparticle:new(love.math.random(self.x + 2, self.x + self.width - 2), love.math.random(self.y, self.y + self.height), love.math.random(10, 20), self.y + self.height, screen, self)
		table.insert(objects["sensor"], temp)
		table.insert(self.particles, temp)
	end

	self.link = r.link
	self.direction = r.direction or "ver"
	print(r.direction, self.direction)
	
	self.dir = "left"
	self.triggered = false
	if self.direction == "hor" then
		self.dir = "up"
	end

	self.start = false
	self.reset = false

	self.outtable = {}

	self.screen = screen
end

function sensor:addOut(obj)
	table.insert(self.outtable, obj)
end

--[[
	14:47 PM - HugoBDesigner: We'll make the trigger be the size of all blocks that the sensor reaches
	14:47 PM - HugoBDesigner: I know, sounds counter-intuitive, but hear me out
	14:47 PM - HugoBDesigner: We'll detect when the player is in that region
	14:48 PM - HugoBDesigner: Then immediately set on a variable on which side he's in (left, right, up, down)
	14:48 PM - HugoBDesigner: If he crosses the middle, we change the side to that and fire output
	14:49 PM - HugoBDesigner: For example
	14:49 PM - HugoBDesigner: if side == "left" and player.x+player.width > self.x+self.width/2 then
								side = "right"
								fire()
							end
	14:49 PM - HugoBDesigner: Of course
	14:49 PM - HugoBDesigner: You'll only do the side checking if the player is within the overall trigger
--]]

function sensor:update(dt)
	self.particleTimer = self.particleTimer + dt
	if self.particleTimer > 0.3 then
		self.particleTimer = 0
	end

	myTrigger = checkrectangle(self.x, self.y, self.width, self.height, {"player"}, self)
	
	if #myTrigger > 0 then
		local objname, obj = unpack(myTrigger[1])
		local dir = "right"
		if self.direction == "hor" then
			dir = "down"
			if obj.y+obj.height/2 < self.y+self.height/2 then
				dir = "up"
			end
		else --ver
			if obj.x+obj.width/2 < self.x+self.width/2 then
				dir = "left"
			end
			
		end
		if self.triggered and dir ~= self.dir then
			self.dir = dir
			self:activate()

			for k, v in pairs(self.particles) do
				v:resetToggle()
			end
		else
			self.triggered = true
			self.dir = dir
		end
	else
		self.triggered = false
	end
end

function sensor:activate()
	for k, v in pairs(self.particles) do
		v:setColor()
	end

	for j = 1, #self.outtable do
		self.outtable[j]:input("toggle")
	end

	sensorSound[1]:play()

	self.start = true
	self.reset = true
end

function sensor:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)

	pushPop(self)
end

sensorparticle = class("sensorparticle")

function sensorparticle:init(x, y, speed, max, screen, sensor)
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
	self.sensor = sensor
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