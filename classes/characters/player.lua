player = class("player")

function player:init(x, y)
	self.x = x
	self.y = y

	self.width = 12
	self.height = 16

	self.category = 2
	self.mask = 
	{
		true, false, true, true,
		true, true, false, false,
		true, true, true, true
	}

	self.active = true

	self.speedx = 0
	self.speedy = 0

	self.gravity = 400

	self.minJumpHeight = 6

	self.leftKey = false
	self.rightKey = false
	self.upKey = false
	self.downKey = false

	self.useKey = false

	self.state = "idle"
	self.animations =
	{
		["idle"] = 1,
		["waiting"] = {rate = 2, cycle = {8, 9}},
		["walk"] = {rate = 8, cycle = {1, 2, 1, 3}},
		["run"] = {rate = 12, cycle = {1, 2, 1, 3}},
		["holdwalk"] = {rate = 8, cycle = {5, 6, 5, 7}},
		["holdidle"] = 5,
		["holdjump"] = 4,
		["jump"] = 4
	}

	self.timer = 0
	self.quadi = 1

	self.scale =
	{
		["right"] = 1,
		["left"] = 2
	}

	self.direction = "right"
	self.doUpdate = true
	self.item = false
	self.falling = false

	self.fade = 1
	self.fadeOut = false

	self.invincible = false
	self.invincibleTimer = 0

	self.keys = 0
	self.draws = true

	self.screen = "top"

	self.idleTimer = 0

	self.distance = 0
end

function player:update(dt)
	if self.falling and self.speedy < 0 then
		if self.speedy < self.minJumpHeight then
			self.speedy = self.speedy * 0.5
		end
	end

	if self.fadeOut then
		self.fade = math.max(self.fade -  dt, 0)
	else
		self.fade = math.min(self.fade + dt, 1)
	end

	if self.invincible then
		self.invincibleTimer = self.invincibleTimer + 12 * dt

		if math.floor(self.invincibleTimer%2) ~= 0 then
			self.draws = false
		else
			self.draws = true
		end

		if self.invincibleTimer > 18 then
			self.invincibleTimer = 0
			self.invincible = false
		end
	end

	self:offscreenCheck()

	if not self.doUpdate then
		self.rightKey = false
		self.leftKey = false
		self.jumping = false
		return
	end

	if self.distance > 0 then
		if math.floor(math.dist(self.x, self.y, self.distance, self.y)) <= 0 then
			self.speedx = 0
			self.distance = 0
		end
	else
		local speed = 0
		if self.rightKey then
			speed = 100
		elseif self.leftKey then
			speed = -100
		end

		self.speedx = speed
	end

	self:animate(dt)
end

function player:updateBox()
	if self.item then
		self.item.x = (self.x + (self.width / 2)) - self.item.width / 2
		self.item.y = self.y - self.item.height / 1.4
	end
end	

function player:draw()
	love.graphics.setScreen(self.screen)

	if self.draws then
		love.graphics.setColor(255, 255, 255, 255 * self.fade)

		local add = 0
		if self.quadi == 4 then
			add = -2
		end

		love.graphics.draw(idiotImage, idiotQuads[self.quadi][self.scale[self.direction]], self.x + add, self.y - 2)
	end

	love.graphics.setColor(255, 255, 255, 255)
end

function player:upCollide(name, data)
	if name == "pipe" then
		if data.direction == "down" then
			if self.upKey then
				data:use(self)
			end
		end
	end

	if name == "bomb" then
		if not data.passive then
			self.item = data:use(self)
		end
	end

	if name == "block" then
		if not self.jumping then
			self:die()
		end
	end

	if name == "enemy" then
		if not data.dead then
			self:die()
		end
		return false
	end
end

function player:downCollide(name, data)
	self.jumping = false
	self.falling = false

	if name == "spikes" or name == "lava" then
		self:die()
	end

	if name == "pipe" then
		if data.direction == "up" then
			if self.downKey then
				data:use(self)
			end
		end
	end

	if name == "enemy" then
		if data.name == "turret" then
			if data.speedy < 0 then
				data:die()
				
				self.jumping = false

				self:jump(true)

				return false
			else
				if not data.dead then
					self:die()
					return false
				end
			end
		end
	end
end

function player:leftCollide(name, data)
	if name == "door" then
		if self.keys > 0 then
			data:unlock(self)
		end
	end

	if name == "box" then
		data.speedx = -16
	end

	if name == "pipe" then
		if data.direction == "right" then
			if self.leftKey then
				data:use(self)
			end
		end
	end

	if name == "enemy" then
		if not data.dead then
			self:die()
		end
		return false
	end
end

function player:rightCollide(name, data)
	if name == "door" then
		if self.keys > 0 then
			data:unlock(self)
		end
	end

	if name == "box" then
		data.speedx = 16
	end

	if name == "pipe" then
		if data.direction == "left" then
			if self.rightKey then
				data:use(self)
			end
		end
	end

	if name == "enemy" then
		if not data.dead then
			self:die()
		end
		return false
	end
end

function player:walk(direction, distance)
	local dist = distance

	if direction == "left" then
		dist = -distance
	end

	self.distance = math.abs(self.x + distance)

	if direction == "right" then
		self.speedx = 100
	else
		self.speedx = -100
	end
end

function player:passiveCollide(name, data)
	if name == "sign" then
		if self.item then
			return
		end

		if self.useKey then
			data:activate()
		end

		if data.dialog.activated then
			self:dialogStuff("sign", data)
		end
	end

	if name == "explosion" then
		self:die()
	end

	if name == "key" then
		data:collect(self)
	end

	if name == "door" then
		if not data.isLocked then
			if self.speedx ~= 0 or self.item or self.fade == 0 or math.floor(self.speedy) ~= 6 then
				return
			end
			data:use(self)
		end
	end

	if name == "laser" then
		if data.on then
			if not self.item then
				self:die()
			end
		end
	end
end

function player:dialogStuff(name, data)
	local data
	for k, v in pairs(objects["dialog"]) do
		if v.activated then
			data = v
			break
		end
	end

	if data then
		if data.current <= #data.text then
			self.speedx = 0
			self.doUpdate = false
			self.timer = 0
		else
			self.doUpdate = true
		end
	end
end

function player:dialogScroll()
	for k, v in ipairs(objects["dialog"]) do
		if v.activated then
			--[[if eventSystem:isRunning() then
				return
			end]]
			v:scrollText()
			self.useKey = false
			break
		end
	end

	self:dialogStuff()
end

function player:die()
	if not self.remove then
		deathSound:play()

		self:dropBox()

		table.insert(objects["player"], death:new(self.x + self.width / 2 - 8, self.y + self.height / 2 - 8, self.screen))
		
		self.remove = true
	end
end

function player:respawn()
	self.invincible = true
end

function player:enterObject(entity, name, fade)
	self.doUpdate = false
	if fade == nil then
		fade = true
	end

	if self.direction == "right" then
		if self.x + self.width / 2 < entity.x + entity.width / 2 then
			self.speedx = 60
			self.state = "walk"
		else
			if self.x > entity.x + entity.width / 2 then
				self.direction = "left"
				return false
			end
			self.speedx = 0
			self.fadeOut = fade
			return true
		end
	else
		if self.x + self.width / 2 > entity.x + entity.width / 2 then
			self.speedx = -60
			self.state = "walk"
		else
			if self.x < entity.x + entity.width / 2 then
				self.direction = "right"
				return false
			end
			self.speedx = 0
			self.fadeOut = fade
			return true
		end
	end
end

function player:getFade()
	return self.fade
end

function player:exit()
	self.transition = true
end

function player:animate(dt)
	local stateAdd = ""
	if self.item then
		stateAdd = "hold"
	end
	
	if self.speedx ~= 0 and self.speedy == 0 then
		self.state = stateAdd .. "walk"
	elseif self.speedy ~= 0 then
		self.state = stateAdd .. "jump"
	elseif self.speedx == 0 and self.speedy == 0 then
		if stateAdd ~= "hold" then
			self.idleTimer = self.idleTimer + dt
			if self.idleTimer > 4 then
				self.state = "waiting"
			else
				self.state = "idle"
			end
		else
			if stateAdd == "hold" or self.idleTimer < 4 then
				self.state = "holdidle"
			end
		end
		
	end

	if (self.state ~= "idle" and self.state ~= "waiting") or (objects and objects["dialog"] and #objects["dialog"] > 0) then
		self.idleTimer = 0
	end

	local anim = self.animations[self.state]

	if not tonumber(anim) then
		self.timer = self.timer + anim.rate * dt
		self.quadi = anim.cycle[math.floor(self.timer % #anim.cycle) + 1]
	else
		self.timer = 0
		self.quadi = anim
	end
end

function player:moveRight(move)
	if not self.doUpdate then
		return
	end

	self.rightKey = move

	if move then
		self.leftKey = false
		self.direction = "right"
	end
end

function player:moveLeft(move)
	if not self.doUpdate then
		return
	end

	self.leftKey = move

	if move then
		self.rightKey = false
		self.direction = "left"
	end
end

function player:moveUp(move)
	if not self.doUpdate then
		return
	end

	self.upKey = move
end

function player:moveDown(move)
	if not self.doUpdate then
		return
	end

	self.downKey = move
end

function player:jump(force)
	if not self.doUpdate or (self.speedy > 0 and not force) then
		return
	end
	
	if not self.jumping then
		jumpSound:play()
		self.speedy = -160
		self.jumping = true
	end
end

function player:stopJump()
	self.falling = true
end

function player:useItem()
	self.useKey = not self.useKey

	if self.useKey then
		--One tile
		local squareSize = 14
		if self.direction == 2 then
			squareSize = -14
		end

		local collide = gameUseRectangle(self.x + (self.width / 2) - squareSize / 2, self.y + (self.height / 2) - squareSize / 2, squareSize, squareSize)

		if #collide > 0 then
			if not self.item then
				for j = 1, #collide do	
					if collide[j].screen == self.screen then
						self.item = collide[j]:use(self)
						break
					end
				end
			end
		end
	end

	if self.item then
		if not self.useKey then
			local add = self.width
			if self.direction == "left" then
				add = -self.item.width - 2
			end

			local ret = checkrectangle(self.x + add, self.y - 16, self.item.width, self.item.height, {"exclude", self.item}, nil, true)
			
			if #ret > 0 then
				print(ret[1][1])
				table.insert(objects["box"], newBoxGhost(self.x + add, self.y, self.screen))
				self.useKey = true
				return
			else
				self:dropBox()
			end
		else
			--hacky solution
			if tostring(self.item) == "bomb" then
				self:dropBox()
			end
		end
	else
		self.useKey = false
	end
end

function player:dropBox()
	if self.item then
		self.item:use(false)
				
		if self.direction == "right" then
			self.item.x = self.x + self.width
		else
			self.item.x = self.x - self.item.width
		end
		self.item.y = self.y + (self.height / 2) - self.item.height / 2
		self.item.speedy = 0
		self.item.speedx = 0

		self.item = false
	end
end

function player:setScreen(screen)
	self.screen = screen
end

function player:offscreenCheck()
	if not objects then
		return
	end

	if self.y > gameFunctions.getHeight() + mapScroll[self.screen][2] then		
		self:die()
	end
end

death = class("death")

function death:init(x, y, screen)
	self.x = x
	self.y = y
	self.width = 16
	self.height = 16
	self.rotation = 0

	self.active = true
	self.passive = true

	local speed = {-40, 40}
	self.speedx = speed[love.math.random(#speed)]

	self.screen = screen
	table.insert(objects["player"], hat:new(self.x + self.width / 2 - 6, self.y + self.height / 2 - 4, -self.speedx, screen))

	self.speedy = -140
	self.gravity = 400
end

function death:update(dt)
	self.rotation = self.rotation + 4 * dt

	if self.y > gameFunctions.getHeight() + mapScroll[self.screen][2] then
		restartMap()
	end
end

function death:draw(homebrew)
	love.graphics.setScreen(self.screen)

	local add = self.width / 2
	if homebrew then
		add = 0
	end

	love.graphics.draw(idiotDeadImage, self.x + add, self.y + add, self.rotation, 1, 1, add, add)
end

hat = class("hat")

function hat:init(x, y, speed, screen)
	self.x = x
	self.y = y
	self.speedx = speed

	self.width = 12
	self.height = 8

	self.active = true
	self.passive = true

	self.mask = {}

	self.speedy = -140
	self.gravity = 400
	self.rotation = 0
	self.screen = screen
end

function hat:update(dt)
	self.rotation = self.rotation + 4 * dt

	if self.y > gameFunctions.getHeight() + mapScroll[self.screen][2] then
		self.remove = true
	end
end

function hat:draw(homebrew)
	love.graphics.setScreen(self.screen)

	local addx, addy = self.width / 2, self.height / 2
	if homebrew then
		addx, addy = 0, 0
	end

	love.graphics.draw(idiotHatImage, self.x + addx, self.y + addy, self.rotation, 1, 1, addx, addy)
end