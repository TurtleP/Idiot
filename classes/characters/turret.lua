turret = class("turret")

function turret:init(x, y, screen)
	self.x = x
	self.y = y

	self.width = 13
	self.height = 14

	self.active = true

	self.gravity = 300

	self.speedx = 0
	self.speedy = 0

	self.mask =
	{
		["tile"] = true,
		["player"] = false
	}

	self.animations =
	{
		["run"] = {rate = 8, cycle = {1, 2, 3, 2}},
		["idle"] = 1,
		["jump"] = 4,
		["fall"] = 5
	}

	self.quadi = 1
	self.scale = 1
	self.timer = 0

	self.jumping = false

	self.screen = screen

	self.targetX = {32, 352}
	self.currentTarget = 1

	self.state = "idle"

	self.name = "turret"

	backgroundMusic:stop()
	bossSong:play()
end

function turret:update(dt)
	if self.dead then
		if objects["player"][1] then
			if not objects["player"][1].animations then
				return
			end

			if self.y > gameFunctions.getHeight() then
				eventSystem:decrypt(mapScripts[7])
				
				bossSong:stop()
				backgroundMusic:play()
				
				table.remove(objects["enemy"], 1)
			end
		end

		return
	end

	if self.currentTarget == 1 then
		self.speedx = -120
		self:faceDirection(2)
	else
		self.speedx = 120
		self:faceDirection(1)
	end

	if self.speedx ~= 0 and not self.jumping then
		self.state = "run"
	elseif self.jumping then
		if self.speedy < 0 then
			self.state = "jump"
		else
			self.state = "fall"
		end
	end

	if math.floor(math.dist(self.x, self.y, self.targetX[self.currentTarget], self.y)) <= 0 then
		if not self.changeDir then
			self.currentTarget = self.currentTarget + 1
			if self.currentTarget > #self.targetX then
				self.currentTarget = 1
			end

			self.changeDir = true
		end
	else
		self.changeDir = false
	end

	--jump the gaps
	if not self.jumping then
		if self.speedy > 0 then
			self.speedy = -100
			self.jumping = true
		end
	end

	self:animate(dt)
end

function turret:animate(dt)
	local anim = self.animations[self.state]

	if type(anim) == "table" then
		self.timer = self.timer + anim.rate * dt
		self.quadi = anim.cycle[math.floor(self.timer % #anim.cycle) + 1]
	else
		self.quadi = anim
		self.timer = 0
	end
end

function turret:faceDirection(dir)
	self.scale = dir
end

function turret:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)

	love.graphics.draw(turretImage, turretQuads[self.quadi][self.scale], self.x, self.y)

	pushPop(self)
end

function turret:downCollide(name, data)
	self.jumping = false
end

function turret:die()
	self.dead = true

	self.speedy = 0
	self.speedx = 0
end