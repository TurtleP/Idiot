laser = class("laser")

function laser:init(x, y, properties, screen)
	self.x = x
	self.y = y

	--self.category = 8
	
	--self.active = true
	--self.static = true
	self.passive = true

	self.mask =
	{
		true, true, false, false
	}

	self.gravity = 0
	self.speedx = 0
	self.speedy = 0

	if properties.width then
		self.width = tonumber(properties.width) * 16
		self.height = 1

		self.x = x - 7.5
		self.y = y + 7.5

		self.dir = "hor"
		self.originalWidth = self.width
	end

	if properties.height then
		self.dir = "ver"
		self.width = 1
		self.height = (tonumber(properties.height) * 16) or 16
		self.originalHeight = self.height
	end

	self.link = properties.link:split(";")

	self.screen = screen

	self.timer = love.math.random(0.2, 0.5)
	self.dotY = self.y
	self.dotX = self.x
	self.on = true
end

function laser:addLink()
	for i, v in pairs(outputs) do
		for j, w in pairs(objects[v]) do
			if w.screen == self.link[1] then
				if w.x == tonumber(self.link[2]) and w.y == tonumber(self.link[3]) then
					w:addOut(self)
					
					self.link = {}
				end
			end
		end
	end
end

function laser:input(t)
	if t == "on" then
		self.on = false
	elseif t == "off" then
		self.on = true
	elseif t == "toggle" then
		self.on = not self.on
	end
end

function laser:update(dt)
	if not self.on then
		return
	end

	self:updateLength()

	if not self.doAnimation then
		if self.timer > 0 then
			self.timer = self.timer - dt
		else
			self.dotY = self.y
			self.doAnimation = true
		end
	else
		if self.dir == "ver" then
			self.dotY = self.dotY + 60 * dt
			if self.dotY > self.y + self.height then
				self.timer = love.math.random(1)
				self.doAnimation = false
			end
		else
			self.dotX = self.dotX + 60 * dt
			if self.dotX > self.x + self.width then
				self.timer = love.math.random(1)
				self.doAnimation = false
			end
		end
	end
end

function laser:updateLength()
	local check = checkrectangle(self.x, self.y, self.width, self.height + 16, {"box", "player"})
	--print(#check)
	if #check > 0 then
		--print(check[1][1])
		if check[1][1] == "player" then
			if not check[1][2].mask then
				return
			end
		end

		if self.dir == "ver" then
			self.height = check[1][2].y - self.y
		else
			self.width = check[1][2].x - self.x
		end
	else
		if self.dir == "ver" then
			self.height = self.originalHeight
		else
			self.width = self.originalWidth
		end
	end
end

function laser:passiveCollide(name, data)
	print(name)
end

function laser:draw()
	love.graphics.setScreen(self.screen)

	if self.on then
		love.graphics.setColor(255, 0, 0)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
		love.graphics.setColor(255, 255, 255)

		if self.doAnimation then
			if self.dir == "ver" then
				love.graphics.rectangle("fill", self.x, self.dotY, self.width, self.width)
			else
				love.graphics.rectangle("fill", self.dotX, self.y, self.height, self.height)
			end
		end
	end
end