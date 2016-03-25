fan = class("fan")

function fan:init(x, y, r, screen)
	self.x = x
	self.y = y

	self.width = 16
	self.height = 16

	self.active = true
	self.static = true

	self.speedx = 0
	self.speedy = 0

	self.timer = 0
	self.quadi = 1

	self.particleTimer = 0

	self.link = r.link:split(";")
	
	self.maxheight = (self.y - (r.maxheight * 16)) or 0

	self.air = true

	self.screen = screen
end

function fan:addLink()
	for k, v in pairs(outputs) do
		for j, w in pairs(objects[v]) do
			if w.addOut then
				if w.screen == self.link[1] then
					if w.x == tonumber(self.link[2]) and w.y == tonumber(self.link[3]) then
						w:addOut(self)
						
						self.link = {}
					end
				end
			end
		end
	end
end

function fan:input(t)
	if t == "on" then
		self.air = false
	elseif t == "off" then
		self.air = true
	elseif t == "toggle" then
		self.air = not self.air
	end
end

function fan:update(dt)
	if self.air then
		local height = self.maxheight
		if self.maxheight == 0 then
			height = self.y
		end

		self.timer = self.timer + 16 * dt
		self.particleTimer = self.particleTimer + dt
		if self.particleTimer > 0.3 then
			table.insert(objects["fan"], fanparticle:new(love.math.random(self.x + 2, self.x + self.width - 2), self.y, self.screen, self.maxheight))
			self.particleTimer = 0
		end

		local obj = checkrectangle(self.x, self.maxheight, self.width, height, {"player", "box"}, self)
		if #obj > 0 then
			for k, v in pairs(obj) do
				local entity = v[2]
				if v[1] == "player" then
					entity.state = "jump"
					entity.falling = false
					entity.jumping = true
				end
				entity.speedy = -60
			end
		end
	else
		self.timer = 0
	end

	self.quadi = math.floor(self.timer % 4) + 1
end

function fan:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)

	love.graphics.draw(fanImage, fanQuads[self.quadi], self.x, self.y)

	pushPop(self)
end

fanparticle = class("fanparticle")

function fanparticle:init(x, y, screen, maxheight)
	self.x = x
	self.y =  y
	self.r = 1
	self.life = 0
	self.maxLife = 2

	self.fade = 1
	self.speed = love.math.random(40, 60)

	self.width = 2
	self.height = 2

	self.passive = true

	self.screen = screen

	self.maxheight = maxheight

	self.originY = y
end

function fanparticle:update(dt)
	self.y = self.y - self.speed * dt

	if self.y < (self.originY + self.maxheight) then
		self.fade = math.max(self.fade - 0.6 * dt, 0)
		if self.fade == 0 then
			self.remove = true
		end
	elseif self.y < 0 then
		self.remove = true
	end
end

function fanparticle:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)
	
	love.graphics.setColor(255, 255, 255, 255 * self.fade)
	love.graphics.rectangle("fill", self.x, self.y, self.r, self.r)
	love.graphics.setColor(255, 255, 255, 255)

	pushPop(self)
end