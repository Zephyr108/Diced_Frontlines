local state = require("game.state")

function love.load()
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
