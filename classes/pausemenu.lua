pausemenu = class("pausemenu")

function pausemenu:init()
	self.options = 
	{
		{"Continue", 
			function() 
				paused = false 
			end
		},
		{"Save and Continue", 
			function() 
				saveGame() 
				
				paused = false 
			end
		},
		{"Save and Quit",
			function()
				saveGame()

				gameFunctions.changeState("title")
			end
		},
		{"Restart map",
			function()
				paused = false

				restartMap()
			end
		}
	}

	self.sineTimer = 0
	self.sineValue = 1

	self.currentOption = 1
end

function pausemenu:update(dt)
	self.sineTimer = self.sineTimer + 0.5 * dt
	self.sineValue = math.abs( math.sin( self.sineTimer * math.pi ) / 2 ) + 0.5
end

function pausemenu:draw()
	love.graphics.setScreen(objects["player"][1].screen)

	local x, y, w, h = gameFunctions.getWidth() / 2 - 72, gameFunctions.getHeight() / 2 - 36, 144, 72

	love.graphics.setColor(0, 0, 0, 200)

	love.graphics.rectangle("fill", x, y, w, h)

	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.print("[ Paused ]", x + (w / 2) - signFont:getWidth("[ Paused ]") / 2, y + 8)

	for k = 1, #self.options do
		local v = self.options[k]

		if self.currentOption == k then
			love.graphics.setColor(255, 255, 255, 255 * self.sineValue)
		else
			love.graphics.setColor(255, 255, 255, 255)
		end
		love.graphics.print(v[1], x + (w / 2) - signFont:getWidth(v[1]) / 2, (y + 24) + (k - 1) * 12)
	end
end

function pausemenu:keypressed(key)
	if key == controls["down"] then
		if self.currentOption < #self.options then
			self.currentOption = self.currentOption + 1
		end
	elseif key == controls["up"] then
		if self.currentOption > 1 then
			self.currentOption = self.currentOption - 1
		end
	elseif key == controls["jump"] then
		self.options[self.currentOption][2]()
	end
end