local endscreen = {}

local message = "Game Over"

function endscreen.load()
end

function endscreen.setMessage(msg)
    message = msg
end

function endscreen.update(dt)
end

function endscreen.draw()
    love.graphics.printf(message, 0, 200, love.graphics.getWidth(), "center")
    love.graphics.printf("Press [SPACE] to return to menu", 0, 240, love.graphics.getWidth(), "center")
end

function endscreen.keypressed(key)
    if key == "space" or key == "return" then
        _G.setState("menu")
    end
end

return endscreen
