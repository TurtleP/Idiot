renhoek = class("ren")

function renhoek:init(x, y, screen, isBoss)
	self.x = x
	self.y = y

	self.width = 15
	self.height = 13

	self.active = true

	self.speedx = 0
	self.speedy = 0

	self.mask =
	{
		true, true, true
	}

	self.category = 11
	
	self.gravity = 400

	self.graphic = renImage
	self.quads = renQuads

	self.timer = 0
	self.quadi = 1

	self.scale = 2

	self.screen = screen

	self.animation = "idle"

	self.animations = 
	{
		["idle"] = 1,
		["walk"] = {rate = 8, cycle = {1, 2, 3, 4}},
		["jump"] = 5,
		["fall"] = 6
	}

	self.distance = 0

	self.direction = "right"

	self.isBoss = isBoss

	self.walkSpeed = 75

	if isBoss then
		self.movement = love.math.random()
		if self.movement < .5 then
			self.direction = "left"
		end
		self.attackTimer = love.math.random(2, 3)
		self.walkSpeed = 96
	end

	self.invincibleTimer = 0
	self.render = true

	self.health = 3

	self.rotation = 0
end

function renhoek:update(dt)
	self:animate(dt)

	if self.isWalking then
		if math.floor(math.dist(self.x, self.y, self.distance, self.y)) > 0 then
			if self.direction == "left" then
				self.speedx = -self.walkSpeed
				self.scale = 2
			elseif self.direction == "right" then
				self.speedx = self.walkSpeed
				self.scale = 1
			end
			self.animation = "walk"
		else
			self.speedx = 0
		end
	end

	if self.passive then
		self.rotation = self.rotation + dt
	end
	
	if self.speedy > 0 then
		self.animation = "fall"

		if self.attacking then
			self:throw()
		end
	end

	if self.invincible then
		self.invincibleTimer = self.invincibleTimer + 8 * dt

		if math.floor(self.invincibleTimer) % 2 == 0 then
			self.render = false
		else
			self.render = true
		end

		if self.invincibleTimer > 14 then
			self.invincible = false
			self.render = true
			self.invincibleTimer = 0
		end
	end

	if self.isBoss then
		if not self.attacking then
			self.isWalking = true

			if self.attackTimer > 0 then
				self.attackTimer = math.max(self.attackTimer - dt, 0)
			end
		end

		if self.y > love.graphics.getHeight() and #objects["dialog"] == 0 then
			gameFadeOut = true

			if gameFade == 1 then
				gameNextLevel()
			end
		end
	end
end

function renhoek:jump()
	if not self.jumping then
		self.speedy = -80

		self.animation = "jump"

		self.jumping = true
	end
end

function renhoek:walk(direction, distance)
	self.direction = direction

	local dist = distance

	if direction == "left" then
		dist = -distance
	end

	self.distance = math.abs(self.x + dist)

	self.isWalking = true
end

function renhoek:throw()
	table.insert(objects["spikes"], block:new(self.x + self.width / 2 - 4, self.y + self.height, "top", {0, 0}))
	
	blockThrowSound:play()
	
	if love.math.random() < .15 then
		if objects["player"][1].x > self.x + self.width / 2 then
			speed = {64, -80}
		else
			speed = {-64, -80}
		end
		table.insert(objects["spikes"], block:new(self.x + self.width / 2 - 4, self.y + self.height, "top", speed))
	end

	self.attackTimer = love.math.random(2, 3)
	self.attacking = false
end

function renhoek:animate(dt)
	if self.speedx == 0 and self.speedy == 0 then
		self.animation = "idle"
	end

	local anim = self.animations[self.animation]

	if not tonumber(anim) then
		self.timer = self.timer + anim.rate * dt
		self.quadi = anim.cycle[math.floor(self.timer % #anim.cycle) + 1]
	else
		self.timer = 0
		self.quadi = anim
	end
end

function renhoek:passiveCollide(name, data)
	if name == "block" then
		if data.hit then
			self:hurt()
		end
	end
end

function renhoek:hurt()
	if not self.invincible then
		self.health = math.max(self.health - 1, 0)
		if self.health == 0 then
			self:jump()
			self.passive = true

			local temp = dialog:new("ren", "AAAAGH! CURSE YOUUU!", true)
			temp:activate()
			table.insert(objects["dialog"], temp)
			
			bossSong:stop()
			
			return
		end
		hitSounds[love.math.random(#hitSounds)]:play()
		self.invincible = true
	end
end

function renhoek:downCollide(name, data)
	if name == "tile" then
		if self.attacking then
			if not self.jumping then
				self.isWalking = false
				self.speedx = 0

				blockPickupSound:play()

				self:jump()

				return false
			end
		end

		if self.attackTimer == 0 then
			if love.math.random() < 1 then
				self.attacking = true
			end
		end
	end
	
	if self.jumping then
		self.jumping = false
	end
end

function renhoek:leftCollide(name, data)
	if name == "tile" then
		self.direction = "right"
		return false
	end
end

function renhoek:rightCollide(name, data)
	if name == "tile" then
		self.direction = "left"
		return false
	end
end

function renhoek:draw()
	love.graphics.setScreen(self.screen)
	
	if not self.render then
		return
	end
	love.graphics.draw(self.graphic, self.quads[self.quadi][self.scale], self.x, self.y, self.rotation)
end

block = class("block")

function block:init(x, y, screen, speed)
	self.x = x 
	self.y = y

	self.width = 16
	self.height = 16
	
	self.category = 9

	self.active = true
	
	self.mask =
	{
		false, true
	}
	
	self.speedx = speed[1] or 0
	self.speedy = speed[2] or 0

	self.gravity = 400
	self.quadi = love.math.random(#blocksQuads)

	self.screen = screen
end

function block:downCollide(name, data)
	if name == "player" then
		if not data.jumping then
			data:die()
		else
			if not self.hit then
				self.speedy = -self.speedy
				self.hit = true
				return false
			else
				data:die()
				return false
			end
		end
	end
end

function block:draw()
	love.graphics.draw(blocksGraphic, blocksQuads[self.quadi], self.x, self.y)
end