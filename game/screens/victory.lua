local victory = {}
local player = require("game.core.player")

function victory.load() end
function victory.update(dt) end

function victory.draw()
    love.graphics.print("Victory!", 100, 100)
    love.graphics.print("You earned: " .. tostring(player.lastReward or 0) .. " gold", 100, 140)
    love.graphics.print("Press Enter to continue...", 100, 180)
end

function victory.keypressed(key)
    if key == "return" or key == "space" then
        _G.setState("shop")
    end
end

return victory