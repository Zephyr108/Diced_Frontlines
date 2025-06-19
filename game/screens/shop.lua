local shop = {}
local items = require("game.data.items")
local player = require("game.core.player")
local units = require("game.data.units")

local selectedItem = 1
local selectedUnit = 1
local selectedFallen = 1
local mode = "weapon" -- lub "addon"
local menuMode = "items" -- albo "revive"

function shop.load()
    selectedItem = 1
    selectedUnit = 1
    selectedFallen = 1
    menuMode = "items"
    mode = "weapon"
end

function shop.update(dt)
    -- na razie puste
end

function shop.draw()
    love.graphics.print("SHOP - " .. mode:upper(), 100, 50)
    love.graphics.print("Gold: " .. player.getMoney(), 100, 80)
    love.graphics.print("Select unit to assign: " .. selectedUnit, 100, 100)

    if menuMode == "items" then
        local list = (mode == "weapon") and items.weapons or items.addons

        for i, item in ipairs(list) do
            local y = 130 + i * 30
            local prefix = (i == selectedItem) and "> " or "  "
            love.graphics.print(prefix .. item.name .. " | Cost: " .. (item.cost or 20), 100, y)
        end

        love.graphics.print("[↑↓] Select item   [Tab] Switch type", 100, 400)
        love.graphics.print("[ [ ] ] Select unit   [Space] Buy", 100, 420)
    elseif menuMode == "revive" then
        love.graphics.print("Revive Fallen Units:", 500, 50)

        local fallen = player.getFallen()
        local fallenYStart = 80
        for i, f in ipairs(fallen) do
            local prefix = (i == selectedFallen) and "> " or "  "
            love.graphics.print(prefix .. f.type .. " (Revive: 50g)", 500, fallenYStart + (i - 1) * 20)
        end

        if #fallen > 0 then
            local preview = fallen[selectedFallen]
            if preview then
                local def = units.definitions[preview.type]
                love.graphics.print("Will revive with HP: " .. def.hp, 500, fallenYStart + #fallen * 20 + 10)
            end
        end

        love.graphics.print("[↑↓] Select fallen   [R] Revive", 500, 420)
    end

    love.graphics.print("[V] Toggle Items / Revive", 100, 460)
    love.graphics.print("[Enter] Next round", 100, 480)
    love.graphics.print("[Esc] Back to Menu", 100, 500)
end

function shop.keypressed(key)
    if key == "v" then
        menuMode = (menuMode == "items") and "revive" or "items"
        return
    end

    local list = (mode == "weapon") and items.weapons or items.addons
    local army = player.getArmy()

    if key == "up" then
        if love.keyboard.isScancodeDown("lshift") or love.keyboard.isScancodeDown("rshift") then
            if #player.getFallen() > 0 then
                selectedFallen = selectedFallen - 1
                if selectedFallen < 1 then selectedFallen = #player.getFallen() end
            end
        else
            selectedItem = selectedItem - 1
            if selectedItem < 1 then selectedItem = #list end
        end
    elseif key == "down" then
        if love.keyboard.isScancodeDown("lshift") or love.keyboard.isScancodeDown("rshift") then
            if #player.getFallen() > 0 then
                selectedFallen = selectedFallen + 1
                if selectedFallen > #player.getFallen() then selectedFallen = 1 end
            end
        else
            selectedItem = selectedItem + 1
            if selectedItem > #list then selectedItem = 1 end
        end
    elseif key == "tab" then
        mode = (mode == "weapon") and "addon" or "weapon"
        selectedItem = 1
    elseif key == "[" then
        selectedUnit = selectedUnit - 1
        if selectedUnit < 1 then selectedUnit = #army end
    elseif key == "]" then
        selectedUnit = selectedUnit + 1
        if selectedUnit > #army then selectedUnit = 1 end
    elseif key == "space" then
        local item = list[selectedItem]
        local cost = item.cost or 20
        if player.spendMoney(cost) then
            local unit = army[selectedUnit]
            if unit then
                if mode == "weapon" then
                    unit.weapon = item
                else
                    unit.addon = item
                end
            end
        end

    elseif key == "r" then
        local fallen = player.getFallen()
        if #fallen > 0 and player.spendMoney(50) then
            player.revive(selectedFallen)
            if selectedFallen > #fallen then
                selectedFallen = #fallen
            end
        end
    elseif key == "return" then
        _G.setState("battle")
    elseif key == "escape" then
        _G.setState("menu")
    end
end

return shop
