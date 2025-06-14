local state = {}
local current = "loadout"  -- możliwe: "loadout", "battle"

local loadout = require("game.loadout")
local battle = require("game.battle")

function state.load()
    loadout.load()
    battle.load()
end

function state.update(dt)
    if current == "loadout" then
        loadout.update(dt)
    elseif current == "battle" then
        battle.update(dt)
    end
end

function state.draw()
    if current == "loadout" then
        loadout.draw()
    elseif current == "battle" then
        battle.draw()
    end
end

function state.keypressed(key)
    if current == "loadout" then
        loadout.keypressed(key)
    elseif current == "battle" then
        if battle.keypressed then
            battle.keypressed(key)
        end
    end
end


function state.setState(newState)
    current = newState
end

return state
