local shop = {}
local items = require("game.items")
local player = require("game.player")

local selectedItem = 1
local mode = "weapon" -- lub "addon"

function shop.load()
    selectedItem = 1
    mode = "weapon"
end

function shop.update(dt)
    -- Możesz dodać animacje lub czas w przyszłości
end

function shop.draw()
    love.graphics.print("SHOP - " .. mode:upper(), 100, 50)
    love.graphics.print("Gold: " .. player.getMoney(), 100, 80)

    local list = (mode == "weapon") and items.weapons or items.addons

    for i, item in ipairs(list) do
        local y = 120 + i * 30
        local prefix = (i == selectedItem) and "> " or "  "
        love.graphics.print(prefix .. item.name .. " | Cost: " .. (item.cost or 20), 100, y)
    end

    love.graphics.print("[Tab] Switch [Space] Buy  [Enter] Next Round  [Esc] Menu", 100, 400)
end

function shop.keypressed(key)
    local list = (mode == "weapon") and items.weapons or items.addons

    if key == "up" then
        selectedItem = selectedItem - 1
        if selectedItem < 1 then selectedItem = #list end
    elseif key == "down" then
        selectedItem = selectedItem + 1
        if selectedItem > #list then selectedItem = 1 end
    elseif key == "tab" then
        mode = (mode == "weapon") and "addon" or "weapon"
        selectedItem = 1
    elseif key == "space" then
        local item = list[selectedItem]
        local cost = item.cost or 20
        if player.spendMoney(cost) then
            local unit = player.getArmy()[1] -- na razie przypisujemy do pierwszej postaci
            if mode == "weapon" then
                unit.weapon = item
            else
                unit.addon = item
            end
        end
    elseif key == "return" then
        _G.setState("battle")
    elseif key == "escape" then
        _G.setState("menu")
    end
end

return shop
