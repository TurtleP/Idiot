notgate = class("notgate")

function notgate:init(x, y, properties, screen)
	self.x = x 
	self.y = y

	self.link = properties.link:split(";")
	self.state = "on"

	self.width = 9
	self.height = 9

	self.initial = true
	self.out = false

	self.active = true
	self.static = true

	self.screen = screen

	self.outtable = {}
end

function notgate:addOut(obj)
	table.insert(self.outtable, obj)
end

function notgate:addLink()
	for k, v in pairs(outputs) do
		for j, w in pairs(objects[v]) do
			if w.screen == self.link[1] then
				print(w.x, w.y)
				if w.x == tonumber(self.link[2]) and w.y == tonumber(self.link[3]) then
					w:addOut(self)

					self.link = {}
				end
			end
		end
	end
end

function notgate:input(t)
	if t == "on" then
		self.state = "off"
	elseif t == "off" then
		self.state = "on"
	else
		if self.state == "off" then
			self.state = "on"
		else
			self.state = "off"
		end
	end

	for k = 1, #self.outtable do
		self.outtable[k]:input(self.state)
	end
end

function notgate:update(dt)
	if self.initial then
		if self.state == "on" then
			self:input("off")
		end
		self.initial = false
	end
end