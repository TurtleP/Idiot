pipe = class("pipe")

function pipe:init(x, y, r, screen)
	self.x = x
	self.y = y

	self.width = 16
	self.height = 16

	self.active = false

	self.mask = {}

	local directions = 
	{
		["up"] = 1,
		["down"] = 2,
		["left"] = 3,
		["right"] = 4,
	}

	self.link = r.link:split(";")
	self.direction = r.direction or "up"
	self.screen = r.screen or "top"

	self.player = nil
	self.quadi = directions[self.direction]
	self.output = false

	self.playSound = false

	self.pipe = nil

	self.screen = screen
end

function pipe:use(player)
	if not self.link or player.item then
		return
	end

	gameFadeOut = true
	self.player = player
end

function pipe:addLink()
	for k, v in pairs(outputs) do
		if v == "pipe" then
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
end

function pipe:addOut(obj)
	self.pipe = obj
end

function pipe:out(direction)
	self.player.downKey = false
	self.player.upKey = false
	
	self.player:setScreen(self.pipe.screen)

	self.player.x, self.player.y = self.pipe.x + self.pipe.width / 2 - self.player.width / 2, self.pipe.y

	self.pipe.player = self.player
	self.player = nil
	
	self.pipe.output = true
end

function pipe:transfer(player, dt)
	if not self.output then
		if self.direction == "up" then
			if player.y < self.y then
				self.player.active = false
				self.player.y = self.player.y + 60 * dt
			else
				return true
			end
		elseif self.direction == "down" then
			if player.y > self.y then
				self.player.active = false
				self.player.y = self.player.y - 60 * dt
			else
				return true
			end
		elseif self.direction == "left" then
			if player.x < self.x then
				self.player.active = false
				self.player.x = self.player.x + 60 * dt
			else
				return true
			end
		elseif self.direction == "right" then
			if player.x > self.x then
				self.player.active = false
				self.player.x = self.player.x - 60 * dt
			else
				return true
			end
		end
	else
		if self.direction == "up" then
			if self.player.y > self.y - self.player.height then
				self.player.y = math.max(self.player.y - 60 * dt, self.y - self.player.height)
			else
				return true
			end
		elseif self.direction == "down" then
			if self.player.y < self.y + self.height then
				self.player.y = math.min(self.player.y + 60 * dt, self.y + self.height)
			else
				return true
			end
		elseif self.direction == "left" then
			if player.x + player.width > self.x then
				self.player.x = math.max(self.player.x - 60 * dt, self.x - player.width)
			else
				return true
			end
		elseif self.direction == "right" then
			if player.x  < self.x + self.width then
				self.player.x = math.min(self.player.x + 60 * dt, self.x + self.width)
			else
				return true
			end
		end
	end
end

function pipe:update(dt)
	if self.player then
		if not self.output then
			if self.direction == "up" or self.direction == "down" then
				if self.player:enterObject(self, "pipe", false) then
					if not self.playSound then
						pipeSound:play()
						self.playSound = true
					end

					if self:transfer(self.player, dt) and gameFade == 1 then
						self:out()
						gameFadeOut = false
						self.playSound = false
					end
				end
			else
				if not self.playSound then
					pipeSound:play()
					self.playSound = true
				end

				if self:transfer(self.player, dt) and gameFade == 1 then
					self:out()
					gameFadeOut = false
					self.playSound = false
				end
			end
		else
			if gameFade == 0 then
				if self:transfer(self.player, dt) then
					self.player.active = true
					self.player.doUpdate = true
					self.player = nil
					self.output = false
				end
			end
		end
	end
end

function pipe:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)
	
	love.graphics.draw(pipeImage, pipeQuads[self.quadi], self.x, self.y)

	pushPop(self)
end