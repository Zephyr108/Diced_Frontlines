local shop = {}
local items = require("game.items")
local player = require("game.player")

local selectedItem = 1
local selectedUnit = 1
local mode = "weapon" -- lub "addon"

function shop.load()
    selectedItem = 1
    selectedUnit = 1
    mode = "weapon"
end

function shop.update(dt)
    -- na razie puste
end

function shop.draw()
    love.graphics.print("SHOP - " .. mode:upper(), 100, 50)
    love.graphics.print("Gold: " .. player.getMoney(), 100, 80)
    love.graphics.print("Select unit to assign: " .. selectedUnit, 100, 100)

    local list = (mode == "weapon") and items.weapons or items.addons

    for i, item in ipairs(list) do
        local y = 130 + i * 30
        local prefix = (i == selectedItem) and "> " or "  "
        love.graphics.print(prefix .. item.name .. " | Cost: " .. (item.cost or 20), 100, y)
    end

    love.graphics.print("[↑↓] Select item   [Tab] Switch type", 100, 400)
    love.graphics.print("[ [ ] ] Select unit   [Space] Buy   [Enter] Next round", 100, 420)
    love.graphics.print("[Esc] Back to Menu", 100, 440)
end

function shop.keypressed(key)
    local list = (mode == "weapon") and items.weapons or items.addons
    local army = player.getArmy()

    if key == "up" then
        selectedItem = selectedItem - 1
        if selectedItem < 1 then selectedItem = #list end
    elseif key == "down" then
        selectedItem = selectedItem + 1
        if selectedItem > #list then selectedItem = 1 end
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
    elseif key == "return" then
        _G.setState("battle")
    elseif key == "escape" then
        _G.setState("menu")
    end
end

return shop
