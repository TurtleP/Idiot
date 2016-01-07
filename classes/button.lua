button = class("button")

function button:init(x, y, r, screen)
	self.x = x
	self.y = y
	self.link = r.link

	self.width = 3
	self.height = 8

	self.outtable = {}

	local directions = 
	{
		["right"] = 1, 
		["left"] = 2
	}

	self.quadi = directions[r.direction] or 1
	self.singleUse = bool(r.singleUse) or false

	if r.direction == "left" then
		self.x = x + 13
	end

	

	self.pressi = 1
	self.timer = 0

	self.useRectangle = gameAddUseRectangle(self.x, self.y, self.width, self.height, self)

	self.screen = screen
end

function button:addOut(obj)
	table.insert(self.outtable, obj)
end

function button:update(dt)
	if not self.singleUse then
		if self.used then
			self.timer = self.timer + dt
			if self.timer > 0.5 then
				self.timer = 0
				self.used = false
			end
		end
	end

	if self.used then
		self.pressi = 2
	else
		self.pressi = 1
	end
end

function button:use()
	if not self.used then
		buttonSound:play()
		self.used = true
	end

	for j = 1, #self.outtable do
		local out = "toggle"
		if self.singleUse then
			out = "on"
		end
		self.outtable[j]:input(out)
	end
end

function button:draw()
	pushPop(self, true)

	love.graphics.setScreen(self.screen)
	love.graphics.draw(buttonImage, buttonQuads[self.pressi][self.quadi], self.x, self.y)

	pushPop(self)
end