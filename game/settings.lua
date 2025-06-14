local settings = {}

local filepath = "settings.cfg"

settings.data = {
    volume = 5,
    fullscreen = false
}

local options = {
    { name = "Volume", key = "volume", min = 0, max = 10 },
    { name = "Fullscreen", key = "fullscreen" },
    { name = "Back", action = true }
}

local selected = 1

function settings.load()
    -- próbujemy wczytać ustawienia z pliku
    if love.filesystem.getInfo(filepath) then
        local contents = love.filesystem.read(filepath)
        local ok, saved = pcall(function() return load("return " .. contents)() end)
        if ok and type(saved) == "table" then
            settings.data = saved
            love.window.setFullscreen(settings.data.fullscreen)
        end
    end
end

function settings.save()
    local serialized = "{" ..
        string.format("volume=%d,", settings.data.volume) ..
        string.format("fullscreen=%s", tostring(settings.data.fullscreen)) ..
    "}"
    love.filesystem.write(filepath, serialized)
end

function settings.update(dt)
end

function settings.draw()
    love.graphics.print("Settings", 100, 50)

    for i, option in ipairs(options) do
        local prefix = (i == selected) and "> " or "  "
        local displayValue = ""

        if option.action then
            displayValue = ""
        elseif option.key == "fullscreen" then
            displayValue = settings.data.fullscreen and "ON" or "OFF"
        else
            displayValue = tostring(settings.data[option.key])
        end

        love.graphics.print(prefix .. option.name .. ": " .. displayValue, 100, 80 + i * 30)
    end
end

function settings.keypressed(key)
    local opt = options[selected]

    if key == "up" then
        selected = selected - 1
        if selected < 1 then selected = #options end
    elseif key == "down" then
        selected = selected + 1
        if selected > #options then selected = 1 end
    elseif key == "left" or key == "right" then
        if not opt.action and opt.key then
            if opt.key == "volume" then
                local delta = (key == "right") and 1 or -1
                settings.data.volume = math.max(opt.min, math.min(opt.max, settings.data.volume + delta))
            elseif opt.key == "fullscreen" then
                settings.data.fullscreen = not settings.data.fullscreen
                love.window.setFullscreen(settings.data.fullscreen)
            end
        end
    elseif key == "return" or key == "space" then
        if opt.name == "Back" then
            settings.save()
            _G.setState("menu")
        end
    end
end

return settings
