renhoek = class("ren")

function renhoek:init(x, y, screen)
	self.x = x
	self.y = y

	self.width = 15
	self.height = 13

	self.active = true

	self.speedx = 0
	self.speedy = 0

	self.mask =
	{
		["tile"] = true,
		["door"] = true
	}

	self.gravity = 400

	self.graphic = renImage
	self.quads = renQuads

	self.timer = 0
	self.quadi = 1

	self.scale = 1

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
end

function renhoek:update(dt)
	self:animate(dt)

	if self.isWalking then
		if math.floor(math.dist(self.x, self.y, self.distance, self.y)) > 0 then
			if self.direction == "left" then
				self.speedx = -75
				self.scale = 2
			elseif self.direction == "right" then
				self.speedx = 75
				self.scale = 1
			end
			self.animation = "walk"
		else
			self.speedx = 0
		end
	end
end

function renhoek:jump()
	if not self.jumping then
		self.speedy = -100

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

function renhoek:jump()

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

function renhoek:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)
	
	love.graphics.draw(self.graphic, self.quads[self.quadi][self.scale], self.x, self.y)

	pushPop(self)
end