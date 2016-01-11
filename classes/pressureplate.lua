plate = class("plate")

function plate:init(x, y, screen)
	self.x = x
	self.y = y

	self.width = 20
	self.height = 5

	self.quadi = 1

	self.playSound = false

	self.outtable = {}

	self.screen = screen
end

function plate:addOut(obj)
	table.insert(self.outtable, obj)
end

function plate:update(dt)
	local obj = checkrectangle(self.x, self.y + 11, self.width, self.height, {"box", "player"}, self)

	--print(#obj)
	if #obj > 0 then
		if obj[1][1] == "player" then
			if not obj[1][2].mask then
				return
			end
		end
		self:out("on")
	else
		self:out("off")
	end
end

function plate:out(t)
	if t == "on" then
		self.quadi = 2

		if not self.playSound then
			plateSound:play()
			self.playSound = true
		end

		for k = 1, #self.outtable do
			self.outtable[k]:input("on")
		end
	else
		self.playSound = false
		self.quadi = 1

		for k = 1, #self.outtable do
			self.outtable[k]:input("off")
		end
	end
end

function plate:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)

	local addx, addy = 0, 11
	if self.quadi == 2 then
		addx = -4
	end

	love.graphics.draw(plateImage, plateQuads[self.quadi], self.x + addx, self.y + addy)

	pushPop(self)
end