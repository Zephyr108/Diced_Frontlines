-- game/ui/roller.lua
local roller = {
    playerResult = nil,
    enemyResult = nil,
    timer = 0,
    displayTime = 2 -- seconds
}

local currentRoll = {
    player = nil,
    enemy = nil
}

function roller.setRoll(target, value)
    if target == "player" then
        currentRoll.player = value
    elseif target == "enemy" then
        currentRoll.enemy = value
    end
end

function roller.getRoll(target)
    if target == "player" then
        return currentRoll.player
    elseif target == "enemy" then
        return currentRoll.enemy
    end
    return nil
end

function roller.showPlayer(result)
    roller.playerResult = result
    roller.timer = roller.displayTime
end

function roller.showEnemy(result)
    roller.enemyResult = result
    roller.timer = roller.displayTime
end

function roller.clear()
    currentRoll.player = nil
    currentRoll.enemy = nil
end

function roller.update(dt)
    if roller.timer > 0 then
        roller.timer = roller.timer - dt
        if roller.timer <= 0 then
            roller.playerResult = nil
            roller.enemyResult = nil
        end
    end
end

function roller.draw()
    if roller.playerResult then
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", 20, 20, 100, 100)
        love.graphics.print("You rolled:", 30, 30)
        love.graphics.print(roller.playerResult, 40, 60)
    end

    if roller.enemyResult then
        local w = love.graphics.getWidth()
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("line", w - 120, 20, 100, 100)
        love.graphics.print("Enemy rolled:", w - 110, 30)
        love.graphics.print(roller.enemyResult, w - 100, 60)
    end
end

return roller
