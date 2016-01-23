dropper = class("dropper")

function dropper:init(x, y, properties, screen)
	self.x = x
	self.y = y

	self.width = 16
	self.height = 16

	self.link = properties.link:split(";")

	self.screen = screen

	local temp = box:new(self.x, self.y, {}, self.screen)
	temp.active = false

	self.box = temp
	table.insert(objects["box"], temp)

	self.quadi = 1

	self.initial = false

	self.timer = 0
	self.closeAnimation = false

	self.out = false
end

function dropper:update(dt)
	if self.out then
		if self.quadi < 9 then
			self.timer = self.timer + 14 * dt
		else
			self.box.active = true

			if self.box.y > self.y + self.height then
				self.out = false
			end
		end
	else
		if self.quadi > 1 then
			self.timer = self.timer - 14 * dt
		end
	end

	if self.box.remove then
		self:reLinkBox()
	end

	self.quadi = math.floor(self.timer % #dropperQuads) + 1
end

function dropper:reLinkBox()
	self.box.passive = true
	self.box.remove = true
	self.box = nil

	local temp = box:new(self.x, self.y, {}, self.screen)
	--temp.active = false

	self.box = temp
	table.insert(objects["box"], temp)
end

function dropper:addLink()
	for k, v in pairs(outputs) do
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

function dropper:input(t)
	if t == "on" or t == "toggle" then
		self:reLinkBox()
		self.out = true
	end
end

function dropper:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)

	love.graphics.draw(dropperImage, dropperQuads[self.quadi], self.x, self.y)

	pushPop(self)
end