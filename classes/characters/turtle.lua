turtle = class("turtle")

function turtle:init(x, y, screen, isSolo)
    self.x = x
    self.y = y

    self.stage = 0

    self.width = 32
    self.height = 32

    self.speedx = -120 
    self.speedy = 0

    self.active = true
    self.mask =
    {
        true, true
    }

    self.gravity = 0

    self.quadi = 1

    self.hits = 0
    self.timer = 0

    self.screen = screen

    self.scale = -1

    self.category = 2

    self.bombTimer = love.math.random(2)

    --I got somewhat bored
    self.dialogs =
    {
        "How DARE you hit me with that!",
        "Grr . . WHY DON'T YOU DIE?!",
        "ARRGH! HUGO WAS A BETTER ARTIST THAN YOU!",
        "for k, v in pai--I'M FINE!",
        "METROID FEDERATION FORCE IS BEST GAME!"
    }

    self.invincible = false
    self.invincibleTimer = 0
    self.render = true

    self.dead = false
    self.deathTimer = 0
    self.realDeathTimer = 0
    self.trueDeath = false

    self.offsets =
    {
        2,
        4,
        6,
        8,
        8
    }

    self.isSolo = isSolo

    if isSolo then
        self.speedx = 0
    end
end

function turtle:update(dt)
    if not self.isSolo then
        if self.dead then
            if not self.trueDeath then
                self.deathTimer = self.deathTimer + dt
                self.realDeathTimer = self.realDeathTimer + dt
                if self.deathTimer > 0.3 then
                    table.insert(objects["bomb"], explosion:new(love.math.random(self.x, self.x + self.width), love.math.random(self.y, self.y + self.height), self.screen))
                    self.deathTimer = 0
                end

                if self.realDeathTimer > 6 then
                    self.trueDeath = true
                    self.remove = true
                end
            end
            return
        end

        if self.invincible then
            self.invincibleTimer = self.invincibleTimer + 8 * dt

            if math.floor(self.invincibleTimer) % 2 == 0 then
                self.render = true
            else
                self.render = false
            end

            if self.invincibleTimer > 12 then
                self.invincibleTimer = 0
                self.render = true
                self.invincible = false
            end
        end

        local offset = 0
        if self.hits > 1 then
            offset = self.offsets[self.hits]
        end

        self.timer = self.timer + 4 * dt
        self.quadi = offset + math.floor(self.timer % 2) + 1

        if self.bombTimer > 0 then
            self.bombTimer = self.bombTimer - dt
        else
            self:throwBomb()
            self.bombTimer = love.math.random(2, 3)
        end
    else
        self.timer = self.timer + 4 * dt
        self.quadi = math.floor(self.timer % 4) + 1
    end
end

function turtle:draw()
    love.graphics.setScreen(self.screen)

    local off = 0
    if self.scale == -1 then
        off = self.width
    end
    
    if not self.render then
        return
    end

    local graphic, quad, off = turtleBossImage, turtleBossQuads, math.sin(love.timer.getTime() * 4) * 6
    if self.isSolo then
        graphic, quad, off = turtleImage, turtleQuads, 0
    end
    love.graphics.draw(graphic, quad[self.quadi], self.x + off, self.y + off, 0, self.scale)
end

function turtle:throwBomb()
    local speed = -80
    if self.scale == 1 then
        speed = 80
    end

    table.insert(objects["bomb"], bomb:new(self.x + (self.width / 2) - 6, self.y + (self.height / 2) - 6, {speed, -64}, self.screen))
end

function turtle:randomDialog()
    local rand = love.math.random(#self.dialogs)

    local temp = dialog:new("turtle", self.dialogs[rand], true)
    temp:activate()
    table.insert(objects["dialog"], temp)

    table.remove(self.dialogs, rand)
end

function turtle:takeDamage()
    if not self.invincible then
        self.hits = math.min(self.hits + 1, 5)

        if self.hits == 5 then
            self:die()
            return
        end

        self:randomDialog()

        self.invincible = true
    end
end

function turtle:die()
    self.dead = true
    self.gravity = 120
    self.mask[1] = false

    local temp = dialog:new("turtle", "NOOOOOOOOOOOOO--!", true)
	temp:activate()
	table.insert(objects["dialog"], temp)
end

function turtle:leftCollide(name, data)
    if name == "tile" then
        self.scale = 1
        self.speedx = -self.speedx
        return false
    end
end

function turtle:rightCollide(name, data)
    if name == "tile" then
        self.scale = -1
        self.speedx = -self.speedx
        return false
    end
end