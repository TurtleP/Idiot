function titleInit()

end

function titleUpdate(dt)

end

function titleDraw()
	love.graphics.setScreen("top")

	love.graphics.setScreen("bottom")
	love.graphics.draw(backgroundImage["bottom"], 0, 0)
end