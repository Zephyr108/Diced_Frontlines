local loadout = {}

local items = require("game.data.items")
local player = require("game.core.player")
local units = require("game.data.units")

local currentUnit = 1
local selecting = "weapon"
local selectedWeapon = 1
local selectedAddon = 1

local classSelectionMode = true
local selectedClass = 1
local availableClasses = {
    { id = "blacksmith", name = "Blacksmith" },
    { id = "gunsmith", name = "Gunsmith" },
    { id = "alchemist", name = "Alchemist" },
}

function loadout.load()
    player.clearArmy()
    player.resetFallen()
    classSelectionMode = true
    selectedClass = 1
    selectedWeapon = 1
    selectedAddon = 1
    currentUnit = 1
end

function loadout.update(dt)
end

function loadout.draw()
    if classSelectionMode then
        love.graphics.print("Select Your Class", 100, 50)

        for i, cls in ipairs(availableClasses) do
            local prefix = (i == selectedClass) and "> " or "  "
            love.graphics.print(prefix .. cls.name, 120, 80 + i * 30)
        end

        -- podgląd kości
        local dice = require("game.data.dice")
        local die = dice[availableClasses[selectedClass].id]
        if die then
            love.graphics.print("Dice: " .. die.name, 400, 80)
            for j, side in ipairs(die.sides) do
                love.graphics.print("- " .. side, 420, 100 + j * 20)
            end
        end

        love.graphics.print("[↑↓] Navigate   [Space] Confirm", 100, 400)
    else
        love.graphics.print("Prepare Your Army (" .. availableClasses[selectedClass].name .. ")", 100, 50)

        local army = player.getArmy()

        for i, unit in ipairs(army) do
            local y = 100 + i * 60
            local prefix = (i == currentUnit) and "> " or "  "
            love.graphics.print(prefix .. unit.type, 100, y)
            love.graphics.print("Weapon: " .. unit.weapon.name, 250, y)
            love.graphics.print("Addon: " .. unit.addon.name, 450, y)
        end

        love.graphics.print("[↑↓] Unit  [←→] Change item  [Tab] Switch Wpn/Addon", 100, 400)
        love.graphics.print("[Space] Start Battle", 100, 420)
    end
end

function loadout.keypressed(key)
    if classSelectionMode then
        if key == "up" then
            selectedClass = selectedClass - 1
            if selectedClass < 1 then selectedClass = #availableClasses end
        elseif key == "down" then
            selectedClass = selectedClass + 1
            if selectedClass > #availableClasses then selectedClass = 1 end
        elseif key == "space" then
            player.setClass(availableClasses[selectedClass].id)
            player.clearArmy()
            for i = 1, 3 do
                player.addUnit({
                    type = "Swordsman",
                    weapon = items.weapons[1],
                    addon = items.addons[1],
                    hp = 10
                })
            end
            classSelectionMode = false
        end
        return
    end

    local army = player.getArmy()
    local unit = army[currentUnit]

    if key == "up" then
        currentUnit = (currentUnit - 2) % #army + 1
    elseif key == "down" then
        currentUnit = (currentUnit) % #army + 1
    elseif key == "tab" then
        selecting = (selecting == "weapon") and "addon" or "weapon"
    elseif key == "left" or key == "right" then
        if selecting == "weapon" then
            selectedWeapon = (key == "right") and selectedWeapon + 1 or selectedWeapon - 1
            if selectedWeapon < 1 then selectedWeapon = #items.weapons end
            if selectedWeapon > #items.weapons then selectedWeapon = 1 end
            unit.weapon = items.weapons[selectedWeapon]
        else
            selectedAddon = (key == "right") and selectedAddon + 1 or selectedAddon - 1
            if selectedAddon < 1 then selectedAddon = #items.addons end
            if selectedAddon > #items.addons then selectedAddon = 1 end
            unit.addon = items.addons[selectedAddon]
        end
    elseif key == "space" then
        _G.setState("battle")
    end
end

return loadout
