local state = {}
local current = "menu"

local menu = require("game.screens.menu")
local loadout = require("game.screens.loadout")
local battle = require("game.screens.battle")
local settings = require("game.core.settings")
local endscreen = require("game.screens.endscreen")
local shop = require("game.screens.shop")
local victory = require("game.screens.victory")

function state.load()
    menu.load()
    settings.load()
    loadout.load()
    battle.load()
    endscreen.load()
    victory.load()
end

function state.update(dt)
    if current == "menu" then
        menu.update(dt)
    elseif current == "settings" then
        settings.update(dt)
    elseif current == "loadout" then
        loadout.update(dt)
    elseif current == "battle" then
        battle.update(dt)
    elseif current == "end" then
        endscreen.update(dt)
    elseif current == "shop" then
        shop.update(dt)
    elseif current == "victory" then
        victory.update(dt)
    end
end

function state.draw()
    if current == "menu" then
        menu.draw()
    elseif current == "settings" then
        settings.draw()
    elseif current == "loadout" then
        loadout.draw()
    elseif current == "battle" then
        battle.draw()
    elseif current == "end" then
        endscreen.draw()
    elseif current == "shop" then
        shop.draw()
    elseif current == "victory" then
        victory.draw()
    end
end

function state.keypressed(key)
    if current == "menu" then
        menu.keypressed(key)
    elseif current == "settings" then
        settings.keypressed(key)
    elseif current == "loadout" then
        loadout.keypressed(key)
    elseif current == "battle" then
        if battle.keypressed then
            battle.keypressed(key)
        end
    elseif current == "end" then
        if endscreen.keypressed then
            endscreen.keypressed(key)
        end
    elseif current == "shop" then
        shop.keypressed(key)
    elseif current == "victory" then
        victory.keypressed(key)
    end
end

function state.setState(newState)
    current = newState
    if current == "battle" then
        battle.load()
    elseif current == "shop" then
        shop.load()
    elseif current == "end" then
        endscreen.load()
    elseif current == "loadout" then
        loadout.load()
    end
end

_G.setState = state.setState

return state
