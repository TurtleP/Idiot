eventsystem = class("eventsystem")

function eventsystem:init()
	self.sleep = 0
	self.i = 0
	self.events = {}
	self.running = false
end

function eventsystem:update(dt)
	if not self.running then
		return
	end
	
	if self.i < #self.events then
		if self.sleep > 0 then
			self.sleep = math.max(0, self.sleep - dt)
		end

		if #objects["dialog"] > 0 then
			self.sleep = dt
		end

		if self.sleep == 0 and self.running then
			self.i = self.i + 1

			local v = self.events[self.i]

			cmd = v.cmd:lower()

			if cmd == "dialog" then
				local temp = dialog:new(unpack(v.args))
				temp:activate()
				table.insert(objects["dialog"], temp)
			elseif cmd == "sleep" then
				self.sleep = v.args
			elseif cmd == "usedoor" then
				for i, s in pairs(objects["door"]) do
					if s.x == v.args[1] and s.y == v.args[2] then
						s:toggleOpen()
					end
				end
			elseif cmd == "spawncharacter" then
				if v.args[1] == "idiot" then
					objects["player"][1] = player:new(_PLAYERSPAWNX, _PLAYERSPAWNY)
				elseif v.args[1] == "ren" then
					table.insert(objects["enemy"], renhoek:new(v.args[2], v.args[3], v.args[4]))
				elseif v.args[1] == "turret" then
					table.insert(objects["enemy"], turret:new(v.args[2], v.args[3], v.args[4]))
				end
			elseif cmd == "walkcharacter" then
				if v.args[1] == "ren" then
					objects["enemy"][1]:walk(v.args[2], v.args[3])
				elseif v.args[1] == "idiot" then
					objects["player"][1]:walk(v.args[2], v.args[3])
				end
			elseif cmd == "removecharacter" then
				if v.args[1] == "ren" then
					table.remove(objects["enemy"], 1)
				end
			elseif cmd == "spawnobject" then
				if v.args[1] == "key" then
					local temp = key:new(v.args[2], v.args[3], objects["player"][1].screen)
					temp:drop()
					table.insert(objects["key"], temp)
				end
			elseif cmd == "facedirection" then
				if v.args[1] == "enemy" then
					objects["enemy"][1]:faceDirection(v.args[2])
				end
			elseif cmd == "freezeplayer" then
				_LOCKPLAYER = true
			elseif cmd == "unfreezeplayer" then
				_LOCKPLAYER = false
			elseif cmd == "shake" then
				shakeIntensity = v.args
			elseif cmd == "changestate" then
				gameFunctions.changeState(v.args)
			elseif cmd == "killplayer" then
				objects["player"][1]:die(true)
			elseif cmd == "fadein" then
				gameFade = 1
				gameFadeOut = false
				fadeValue = v.args or 1
			elseif cmd == "disable" then
				self.disabled = true
			elseif cmd == "fadeout" then
				gameFade = 0
				gameFadeOut = true
				fadeValue = v.args or 1
			elseif cmd == "nextlevel" then
				gameNextLevel()
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
		if cmd == "levelequals" then
			if currentLevel ~= arg then
				print("Won't load script {Level Equals: " .. arg .. "} (doesn't belong to level!)")
				break
			else
				print("Using script {Level Equals: " .. arg .. "}")
			end
		end
		self.running = true

		self:queue(cmd, arg)
	end
end