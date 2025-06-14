local loadout = {}
local classes = { "Blacksmith", "Gunsmith" }
local selected = 1

function loadout.load()
end

function loadout.update(dt)
end

function loadout.draw()
    love.graphics.print("Select Your Class:", 100, 100)
    for i, class in ipairs(classes) do
        local prefix = (i == selected) and "> " or "  "
        love.graphics.print(prefix .. class, 120, 100 + i * 30)
    end
    love.graphics.print("Press [SPACE] to start", 100, 250)
end

function loadout.keypressed(key)
    if key == "up" then
        selected = selected - 1
        if selected < 1 then selected = #classes end
    elseif key == "down" then
        selected = selected + 1
        if selected > #classes then selected = 1 end
    elseif key == "space" then
        -- zapisz wybraną klasę do globalnego stanu gracza
        require("game.player").setClass(classes[selected])
        require("game.state").setState("battle")
    end
end

return loadout
