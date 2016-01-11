teleporter = class("teleporter")

function teleporter:init(x, y, r, screen)
	self.x = x
	self.y = y

	self.width = 16
	self.height = 32

	self.speedx = 0
	self.speedy = 0

	self.link = r.link:split(";")

	self.open = false
	self.closeAnimation = false

	self.timer = 0
	self.quadi = 1
	self.player = nil

	self.teleported = false
	self.canTeleport = true

	self.teleporter = nil

	self.screen = screen
end

function teleporter:use(player)
	self.open = true

	self.player = player
end

function teleporter:addOut(obj)
	self.teleporter = obj
end

function teleporter:addLink()
	for k, v in pairs(outputs) do
		if v == "teleporter" then
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

function teleporter:out()
	local w = self.teleporter

	if not w.teleported then
		self.player.x, self.player.y = w.x+w.width/2-self.player.width/2, w.y+w.height-self.player.height
		w:use(self.player, true)
		
		teleportSound:play()

		self.player.fadeOut = false
		self.player.doUpdate = true

		w.canTeleport = false
		w.teleported = true
	end
end

function teleporter:update(dt)
	if self.open then
		if self.quadi < 6 then
			self.timer = self.timer + 16 * dt
			self.quadi = math.floor(self.timer % 6) + 1
		else
			if not self.teleported then
				if self.player:enterObject(self) then
					if self.player:getFade() == 0 then
						self.open = false
						self.teleported = true
						self.closeAnimation = true
					end
				end
			else
				self.open = false
				self.closeAnimation = true
			end
		end
	else
		local check = checkrectangle(self.x, self.y, self.width, self.height, {"player"})

		if self.closeAnimation then
			if self.quadi > 1 then
				self.timer = self.timer - 12 * dt
				self.quadi = math.floor(self.timer % 6) + 1
			else
				
				if #check > 0 then
					if self.teleported and self.canTeleport then
						self:out()
					end
				end
				
				self.timer = 0
				self.closeAnimation = false
			end
		end
	
		if #check == 0 then
			if self.teleported then
				self.teleported = false
				self.canTeleport = true
			end
		end
	end
end

function teleporter:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)

	love.graphics.draw(teleporterImage, teleporterQuads[self.quadi], self.x, self.y)

	pushPop(self)
end