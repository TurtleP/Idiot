delayer = class("delayer")

function delayer:init(x, y, properties, screen)
	self.x = x
	self.y = y

	self.time = tonumber(properties.time) or 2

	self.out = false

	self.width = 9
	self.height = 9

	self.outtable = {}
	self.link = properties.link:split(";")

	self.screen = screen

	self.timer = 0
end

function delayer:addOut(obj)
	table.insert(self.outtable, obj)
end

function delayer:addLink()
	for k, v in pairs(outputs) do
		for j, w in pairs(objects[v]) do
			if w.addOut then
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

function delayer:update(dt)
	if self.out then
		if self.timer < self.time then
			self.timer = self.timer + dt

			if not timeSound:isPlaying() and not buttonSound:isPlaying() then
				timeSound:play()
			end
		else
			timeSound:stop()
			for k = 1, #self.outtable do
				self.outtable[k]:input("on")
			end
		end
	end
end

function delayer:input(t)
	if t == "on" then
		self.out = true
	elseif t == "off" then
		self.out = false
	elseif t == "toggle" then
		self.out = not self.out
	end
end

function delayer:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(delayerImage, delayerQuads[1], self.x, self.y)
	love.graphics.setColor(unpack(colorfade(self.timer, self.time, {0, 200, 0}, {200, 0, 0})))
	love.graphics.draw(delayerImage, delayerQuads[2], self.x, self.y)
	love.graphics.setColor(255, 255, 255)

	pushPop(self)
end