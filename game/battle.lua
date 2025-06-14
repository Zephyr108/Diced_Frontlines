local battle = {}
local player = require("game.player")
local units = require("game.units")
local endscreen = require("game.endscreen")

local enemyArmy = {}
local selectedUnitIndex = 1
local selectedTargetIndex = 1
local turn = "player"

function battle.load()
    -- RESETUJ ARMIE WROGÓW
    battle.generateEnemies()

    -- RESETUJ HP GRACZA
    local army = player.getArmy()
    for _, unit in ipairs(army) do
        local def = require("game.units").definitions[unit.type]
        unit.hp = def.hp
    end

    -- RESETUJ WSZYSTKO INNE
    selectedUnitIndex = 1
    selectedTargetIndex = 1
    turn = "player"
end


function battle.update(dt)
    -- nic na razie, bo tury sterowane są przez gracza
end

function battle.draw()
    love.graphics.print("Turn: " .. turn, 100, 20)

    -- Gracz
    local army = player.getArmy()
    for i, unit in ipairs(army) do
        local tileSize = 48
        local x = 150 + (unit.x - 1) * tileSize
        local y = 150 + (unit.y - 1) * tileSize

        love.graphics.rectangle("line", x, y, tileSize, tileSize)
        love.graphics.print(unit.type .. " HP: " .. unit.hp, x + 4, y + 4)

        if i == selectedUnitIndex and turn == "player" then
            love.graphics.rectangle("line", x - 2, y - 2, tileSize + 4, tileSize + 4)
        end
    end

    -- Wrogowie
    for i, unit in ipairs(enemyArmy) do
        local tileSize = 48
        local x = 100 + (unit.x - 1) * tileSize
        local y = 150 + (unit.y - 1) * tileSize

        love.graphics.rectangle("line", x, y, tileSize, tileSize)
        love.graphics.print("Enemy HP: " .. unit.hp, x + 4, y + 4)

        if i == selectedTargetIndex and turn == "player" then
            love.graphics.rectangle("line", x - 2, y - 2, tileSize + 4, tileSize + 4)
        end
    end
end

function battle.keypressed(key)
    if key == "escape" then
        player.clearArmy()
        enemyArmy = {}
        _G.setState("menu")
    end

    if turn ~= "player" then return end

    local army = player.getArmy()

    if key == "up" then
        selectedUnitIndex = selectedUnitIndex - 1
        if selectedUnitIndex < 1 then selectedUnitIndex = #army end
    elseif key == "down" then
        selectedUnitIndex = selectedUnitIndex + 1
        if selectedUnitIndex > #army then selectedUnitIndex = 1 end
        elseif key == "left" then
        selectedTargetIndex = selectedTargetIndex - 1
        if selectedTargetIndex < 1 then selectedTargetIndex = #enemyArmy end
    elseif key == "right" then
        selectedTargetIndex = selectedTargetIndex + 1
        if selectedTargetIndex > #enemyArmy then selectedTargetIndex = 1 end

    elseif key == "return" or key == "space" then
        local attacker = army[selectedUnitIndex]
        local target = enemyArmy[selectedTargetIndex]
        if not attacker or not target then return end

        target.hp = target.hp - attacker.damage
        if target.hp <= 0 then
            table.remove(enemyArmy, selectedTargetIndex)
            if selectedTargetIndex > #enemyArmy then selectedTargetIndex = #enemyArmy end
        end

        turn = "enemy"
        battle.enemyTurn()

        target.hp = target.hp - attacker.damage
        if target.hp <= 0 then
            for i, u in ipairs(enemyArmy) do
                if u == target then table.remove(enemyArmy, i) break end
            end
        end
        turn = "enemy"
        battle.enemyTurn()
    end
end

-- GENERATOR ARMII WROGA
function battle.generateEnemies()
    enemyArmy = {
        units.create("Swordsman", 5, 1),
        units.create("Swordsman", 5, 2),
        units.create("Swordsman", 5, 3)
    }
end

function battle.enemyTurn()
    local army = player.getArmy()

    for _, enemy in ipairs(enemyArmy) do
        if #player.getArmy() == 0 then return end
        if #army == 0 then break end
        local target = army[math.random(#army)]
        target.hp = target.hp - enemy.damage
        if target.hp <= 0 then
            for i, u in ipairs(army) do
                if u == target then table.remove(army, i) break end
            end
        end
    end

    -- sprawdź, czy ktoś wygrał
    if #enemyArmy == 0 then
        endscreen.setMessage("Victory!")
        _G.setState("end")
    elseif #army == 0 then
        endscreen.setMessage("Defeat!")
        _G.setState("end")
    else
        turn = "player"
    end
end

return battle
