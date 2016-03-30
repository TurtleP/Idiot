andgate = class("andgate")

function andgate:init(x, y, properties, screen)
	self.x = x
	self.y = y

	self.width = 9
	self.height = 9

	self.links = properties.link:split("-")

	self.link = {}
	for k = 1, #self.links do
		table.insert(self.link, self.links[k])
	end

	self.screen = screen

	self.outtable = {}
	self.objects = {}

	self.out = 0
end

function andgate:input(t)
	if t == "on" then
		self.out = math.min(self.out + 1, #self.link)
	elseif t == "off" then
		self.out = 0
	end
	
	if self.out == #self.link then
		for j = 1, #self.outtable do
			self.outtable[j]:input("on")
		end
	else
		for j = 1, #self.outtable do
			self.outtable[j]:input("off")
		end
	end
end

function andgate:addLink()
	for k, v in pairs(outputs) do
		for j, w in pairs(objects[v]) do
			for i = 1, #self.links do
				if self.links[i] then
					local s = self.links[i]:split(";")
					if w.screen == s[1] then
						if w.x == tonumber(s[2]) and w.y == tonumber(s[3]) then
							w:addOut(self)
							table.remove(self.links, i)
						end
					end
				end
			end
		end
	end
end

function andgate:addOut(obj)
	table.insert(self.outtable, obj)
end