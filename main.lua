local state = require("game.core.state")

function love.load()
    local icon = love.image.newImageData("assets/gfx/icon.png")
    love.window.setIcon(icon)
    state.load()
end

function love.update(dt)
    state.update(dt)
end

function love.draw()
    state.draw()
end

function love.keypressed(key)
    state.keypressed(key)
end
