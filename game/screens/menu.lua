local menu = {}

local options = { "New Game", "Continue", "Settings", "Quit" }
local selected = 1

function menu.load()
end

function menu.update(dt)
end

function menu.draw()
    love.graphics.print("Diced Frontlines", 100, 50)
    for i, option in ipairs(options) do
        local prefix = (i == selected) and "> " or "  "
        love.graphics.print(prefix .. option, 100, 100 + i * 30)
    end
end

function menu.keypressed(key)
    if key == "up" then
        selected = selected - 1
        if selected < 1 then selected = #options end
    elseif key == "down" then
        selected = selected + 1
        if selected > #options then selected = 1 end
    elseif key == "return" or key == "space" then
        local choice = options[selected]
        if choice == "New Game" then
            _G.setState("loadout")
        elseif choice == "Continue" then
            -- jeszcze nie zaimplementowane
        elseif choice == "Settings" then
            _G.setState("settings")
        elseif choice == "Quit" then
            love.event.quit()
        end
    end
end

return menu
