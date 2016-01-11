door = class("door")

function door:init(x, y, r, screen)
	self.x = x
	self.y = y

	self.width = 16
	self.height = 32

	self.quadi = 1

	self.timer = 0

	self.isStart = bool(r.start)

	self.isLocked = bool(r.locked)

	if r.link then
		self.link = r.link:split(";")
	end

	self.open = false
	self.closeAnimation = false

	self.player = nil

	self.unlocked = false

	if self.isLocked then
		self.active = true
		self.static = true
		self.passive = false
		self.width = 5
	else
		self.passive = true
	end

	self.playSound = false

	self.screen = screen
end

function door:use(player)
	if self.isStart then
		return
	end
	self.open = true
	self.player = player
end

function door:addLink()
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

function door:update(dt)
	if not self.isLocked then
		self:normalDoor(dt)
	else
		if self.unlocked then
			self:unlockDoor(dt)
		else
			self:lockDoor(dt)
		end
	end
end

function door:unlock(player)
	if #self.link > 1 then
		return
	end

	player.keys = player.keys - 1
	self.unlocked = true
end

function door:input(t)
	if t == "on" then
		self.unlocked = true
	elseif t == "off" then
		self.unlocked = false
	elseif t == "toggle" then
		self.unlocked = not self.unlocked
	end
end

function door:normalDoor(dt)
	if self.open then
		if self.quadi < 3 then
			self.timer = self.timer + 16 * dt
			self.quadi = math.floor(self.timer % 3) + 1
		else
			if self.player:enterObject(self, "door") then
				self.open = false
				self.closeAnimation = true
			end
		end
	else
		if self.closeAnimation then
			if self.quadi > 1 then
				self.timer = self.timer - 12 * dt
				self.quadi = math.floor(self.timer % 3) + 1
			else
				self.player.remove = true
				gameNextLevel()
				self.closeAnimation = false
				self.timer = 0
			end
		end
	end
end

function door:unlockDoor(dt)
	if not self.playSound then
		unlockSound:play()
		self.playSound = true
	end
	
	if self.quadi < 3 then
		self.timer = self.timer + 16 * dt
		self.quadi = math.floor(self.timer % 3) + 1
	else
		self.passive = true
	end
end

function door:lockDoor(dt)
	if self.quadi > 1 then
		self.timer = self.timer - 16 * dt
		self.quadi = math.floor(self.timer % 3) + 1
	else
		self.passive = false
		self.playSound = false
	end
end

function door:draw()
	pushPop(self, true)

	love.graphics.setScreen(self.screen)

	if self.isStart or (self.isLocked and self.unlocked) then
		love.graphics.setColor(127, 127, 127)
	end

	local image = 1
	if self.isLocked then
		image = 2
	end

	love.graphics.draw(doorImage, doorQuads[self.quadi][image], self.x, self.y)	
	love.graphics.setColor(255, 255, 255)

	pushPop(self)
end