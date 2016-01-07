sign = class("sign")

function sign:init(x, y, r, screen)
	self.x = x
	self.y = y

	self.width = 16
	self.height = 16

	self.passive = true

	self.r = r.text or ""

	self.useRectangle = gameAddUseRectangle(self.x, self.y, self.width, self.height, self)
	
	local temp = dialog:new(self.r, false, false, self, screen)
	table.insert(objects["dialog"], temp)
	self.dialog = temp

	self.screen = screen
end

function sign:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)

	love.graphics.setFont(signFont)

	love.graphics.draw(objectSet, objectQuads[2], self.x, self.y)
	
	pushPop(self)
end

function sign:use()
	self.dialog:activate()
end

function sign:reset()
	self.dialog = nil

	if not self.dialog then
		local temp = dialog:new(self.r, false, false, self, self.screen)
		table.insert(objects["dialog"], temp)
		self.dialog = temp
	end
end

dialog = class("dialog")

function dialog:init(text, character, autoscroll, sign, screen)
	self.drawText = ""
	self.current = 0

	self.color = color

	self.static = true

	self.x = 2
	self.height = 18
	self.width = gameFunctions.getWidth() - 4
	self.y = 2

	self.timer = 0
	self.delay = 0.05

	self.lifeTime = 0

	self.currentText = 1

	self.text = text

	self.doScroll = false
	self.stop = false
	self.maxChars = 48

	if character == "idiot" then
		self.character = idiotHeadImage
	end

	self.canScroll = false
	self.activated = false
	self.autoscroll = autoscroll
	self.sign = sign

	self.screen = screen or "top"
end

function dialog:activate()
	self.activated = true
end

function dialog:update(dt)
	if not self.activated then
		return
	end

	--if self.currentText <= #self.texts then
	if self.current <= #self.text and not self.doScroll then
		self.timer = self.timer + dt
		if self.timer > self.delay then
			self.drawText = self.drawText .. self.text:sub(self.current, self.current)
			self.current = self.current + 1
			self.timer = 0
		end
	else
		self.canScroll = true
		if self.autoscroll then
			self.doScroll = true
		end

		if self.doScroll then
			self.lifeTime = self.lifeTime + dt
			if self.lifeTime > 1 then
				if self.sign then
					self.sign:reset()
				end
				self.activated = false
				self.remove = true
			end
		end
	end
end

function dialog:scrollText()
	if not self.activated then
		return
	end

	if not self.canScroll then
		self.drawText = self.text
		self.current = #self.text+1
		return
	end

	if not self.doScroll then
		self.doScroll = true
	end
end

function dialog:draw()
	pushPop(self, true)
	love.graphics.setScreen(self.screen)

	if self.activated then
		love.graphics.setColor(0, 0, 0, 200)
		love.graphics.rectangle("fill", self.x, self.y, love.graphics.getWidth() - 4, self.height)
		love.graphics.setColor(255, 255, 255, 255)

		local off = 0
		if self.character then
			off = 26
			love.graphics.draw(self.character, self.x + 2, self.y + (self.height / 2) - self.character:getHeight() / 2)
		end

		love.graphics.print(self.drawText, self.x + 4 + off, self.y + 3 + (self.height / 2) - signFont:getHeight() / 2)

		if #self.drawText == #self.text and not self.stop then
			love.graphics.draw(scrollArrow, self.x + off + love.graphics.getWidth() - 18, self.y + (self.height - 4) + math.sin(love.timer.getTime() * 8))
		end
	end

	pushPop(self)
end