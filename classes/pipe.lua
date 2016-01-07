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
		["middle"] = 2,
		["down"] = 3
	}

	self.link = r.link
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
				if w ~= self then
					if w.link == self.link then
						w:addOut(self)
						break
					end
				end
			end
		end
	end
end

function pipe:addOut(obj)
	self.pipe = obj
end

function pipe:out()
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
		else
			if player.y > self.y then
				self.player.active = false
				self.player.y = self.player.y - 60 * dt
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
		else
			if self.player.y < self.y + self.height then
				self.player.y = math.min(self.player.y + 60 * dt, self.y + self.height)
			else
				return true
			end
		end
	end
end

function pipe:update(dt)
	if self.player then
		if not self.output then
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