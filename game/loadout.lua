local loadout = {}

local items = require("game.items")
local player = require("game.player")

local currentUnit = 1
local selecting = "weapon" -- lub "addon"
local selectedWeapon = 1
local selectedAddon = 1

function loadout.load()
    player.clearArmy()
    for i = 1, 3 do
        player.addUnit({
            type = "Swordsman", -- domyślna
            weapon = items.weapons[1],
            addon = items.addons[1]
        })
    end
end

function loadout.update(dt)
end

function loadout.draw()
    love.graphics.print("Prepare Your Army", 100, 50)

    local army = player.getArmy()

    for i, unit in ipairs(army) do
        local y = 100 + i * 60
        local prefix = (i == currentUnit) and "> " or "  "
        love.graphics.print(prefix .. unit.type, 100, y)
        love.graphics.print("Weapon: " .. unit.weapon.name, 250, y)
        love.graphics.print("Addon: " .. unit.addon.name, 450, y)
    end

    love.graphics.print("[Arrow keys] Change  [Tab] switch  [Space] Confirm", 100, 350)
end

function loadout.keypressed(key)
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
        _G.setState("battle") -- zamiast require("game.state")
    end
end

return loadout
