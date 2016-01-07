function titleInit()

end

function titleUpdate(dt)

end

function titleDraw()
	drawTitleScreen()

	drawTitleScreenGUI()
end

function drawTitleScreen()
	love.graphics.draw(titleImage)
end

function drawTitleScreenGUI()
	--draw stuff
	love.graphics.print("This is option A", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
end