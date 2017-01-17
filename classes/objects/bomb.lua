bomb = class("bomb")

function bomb:init(x, y, speed, screen)
    self.x = x
    self.y = y

    self.width = 12
    self.height = 12

    self.active = true

    self.speedx = speed[1]
    self.speedy = speed[2]

    self.mask = 
	{
		true, true, true, true,
		true, true, false, false,
		true, true, true, true
	}

    self.screen = screen
    self.gravity = 400

    self.bounces = 0

    self.timer = 0
    self.quadi = 1

    self.rate = 0

    self.rocket = false
    self.canRocket = false
end

function bomb:update(dt)
    self.rate = self.rate + dt

    self.timer = self.timer + ((self.rate / 1) * 8) * dt
    self.quadi = math.floor(self.timer % 2) + 1

    if self.timer > 24 then
        self:explode()
        self.timer = 0
    end
end

function bomb:draw()
    love.graphics.setScreen(self.screen)
    love.graphics.draw(bombImage, bombQuads[self.quadi], self.x, self.y)
end

function bomb:leftCollide(name, data)
    self.speedx = -self.speedx
end

function bomb:downCollide(name, data)
    if name == "tile" then
        if self.bounces < 1 then
            self.bounces = self.bounces + 1
            self.speedy = -self.speedy * 0.3
            return false
        end
    end

    if name == "player" then
        if not self.parent then
		    data.item = self:use(data)
        end
	end

    if name == "lava" then
        if not self.canRocket then
            self:explode()
            return
        end
        self.speedy = -360
        self.rocket = true
    end
end

function bomb:upCollide(name, data)
    if self.speedy < 0 then
        if name == "enemy" and self.rocket then
            data:takeDamage()
            self:explode()
            return false
        end
    else
        if name == "tile" then
            self:explode()
        end
    end
end

function bomb:rightCollide(name, data)
    self.speedx = -self.speedx
end

function bomb:use(player)
	self.parent = player

    self.canRocket = true

	local active = true
	if player then
		active = false
	end
	self.passive = not active

	return self
end

function bomb:explode()
    if self.parent then
		return
	end

    self.remove = true
    table.insert(objects["bomb"], explosion:new(self.x + (self.width / 2) - 8, self.y + (self.height / 2) - 8, self.screen))
end

explosion = class("explosion")

function explosion:init(x, y, screen)
    self.x = x
    self.y = y

    self.passive = true
    self.static = true

    self.width = 16
    self.height = 16

    self.screen = screen

    self.timer = 0
    self.quadi = 1

    explosionSound:play()
end

function explosion:update(dt)
    if self.quadi < 6 then
        self.timer = self.timer + 8 * dt
        self.quadi = math.floor(self.timer % 6) + 1
    else
        self.remove = true
    end
end

function explosion:draw()
    love.graphics.draw(explosionImage, explosionQuads[self.quadi], self.x, self.y)
end