eventsystem = class("eventsystem")

function eventsystem:init()
	self.sleep = 0
	self.i = 0
	self.events = {}
	self.running = true
end

function eventsystem:update(dt)
	if self.i < #self.events then
		if self.sleep > 0 then
			self.sleep = math.max(0, self.sleep - dt)
		end

		if self.sleep == 0 and self.running then
			self.i = self.i + 1

			local v = self.events[self.i]

			if v.cmd == "dialog" then
				local temp = dialog:new(unpack(v.args))
				temp:activate()
				table.insert(objects["dialog"], temp)
			elseif v.cmd == "wait" then
				self.sleep = v.args
			elseif v.cmd == "spawnPlayer" then
				objects["player"][1] = player:new(_PLAYERSPAWNX, _PLAYERSPAWNY)
			elseif v.cmd == "freezeplayer" then
				_LOCKPLAYER = true
			elseif v.cmd == "unfreezeplayer" then
				_LOCKPLAYER = false
			elseif v.cmd == "shake" then
				shakeIntensity = v.args
			elseif v.cmd == "changeState" then
				gameFunctions.changeState(v.args)
			elseif v.cmd == "killPlayer" then
				objects["player"][1]:die(true)
			end
		end
	else
		if self.running then
			self.running = false
		end
	end
end

function eventsystem:queue(e, args)
	table.insert(self.events, {cmd = e, args = args})
end

function eventsystem:clear()
	self.events = {}
end

function eventsystem:decrypt(scriptString)
	for k, v in ipairs(scriptString) do
		local cmd, arg = v[1], v[2]
		if cmd == "levelEquals" then
			print("!")
			if currentLevel ~= arg then
				print("INVALID LEVEL")
				self.running = false
				return
			end
			self.running = true
		end
		self:queue(cmd, arg)
	end
end