local battle = {}
local player = require("game.player")
local units = require("game.units")
local endscreen = require("game.endscreen")

local enemyArmy = {}
local selectedUnitIndex = 1
local selectedTargetIndex = 1
local turn = "player"
local enemyTurnIndex = 1

function battle.load()
    battle.generateEnemies()

    local army = player.getArmy()
    for i, unit in ipairs(army) do
        local def = require("game.units").definitions[unit.type]
        unit.hp = def.hp
        unit.x = 1
        unit.y = i
    end

    selectedUnitIndex = 1
    selectedTargetIndex = 1
    turn = "player"
    enemyTurnIndex = 1
end

function battle.update(dt)
    if #enemyArmy == 0 then
        local reward = 50 + player.getRound() * 10
        player.addMoney(reward)
        player.lastReward = reward
        player.nextRound()
        _G.setState("victory")
        return
    end
    if turn == "enemy" and enemyTurnIndex <= #enemyArmy then
        battle.processEnemyTurn()
    end
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
        local weapon = unit.weapon or { damage = 0 }
        love.graphics.print(unit.type .. " HP: " .. unit.hp .. " Dmg: " .. weapon.damage, x + 4, y + 4)

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

        local weapon = attacker.weapon or { damage = 0 } 
        local addon = attacker.addon or {}

        local bonus = 0
        if addon.armor then bonus = bonus - 1 end
        if addon.crit then bonus = bonus + 1 end
        if addon.magic then bonus = bonus + 2 end

        local totalDamage = (weapon.damage or 0) + bonus
        target.hp = target.hp - totalDamage

        if target.hp <= 0 then
            table.remove(enemyArmy, selectedTargetIndex)
            if selectedTargetIndex > #enemyArmy then
                selectedTargetIndex = #enemyArmy
            end
        end

        turn = "enemy"
    end
end

function battle.generateEnemies()
    local r = player.getRound()
    enemyArmy = {}

    local enemyTypes = {
        { type = "Swordsman", hp = 10, damage = 3 },
        { type = "Archer", hp = 7, damage = 4 },
        { type = "Brute", hp = 15, damage = 1 }
    }

    for i = 1, 3 do
        local t = enemyTypes[math.random(#enemyTypes)]
        local unit = {
            type = t.type,
            hp = t.hp + r * 2,
            weapon = { damage = t.damage + math.floor(r * 0.8) },
            x = 5,
            y = i
        }
        table.insert(enemyArmy, unit)
    end
end

function battle.processEnemyTurn()
    local army = player.getArmy()
    if #enemyArmy == 0 or #army == 0 then
        endscreen.setMessage("Defeat!")
        _G.setState("end")
        return
    end

    local enemy = enemyArmy[math.random(#enemyArmy)]
    local target = army[math.random(#army)]
    local weapon = enemy.weapon or { damage = 0 }
    local addon = enemy.addon or {}

    local bonus = 0
    if addon.crit then bonus = bonus + 1 end
    if addon.magic then bonus = bonus + 2 end

    local totalDamage = (weapon.damage or 0) + bonus
    target.hp = target.hp - totalDamage

    if target.hp <= 0 then
        for i, u in ipairs(army) do
            if u == target then
                table.remove(army, i)
                break
            end
        end
    end

    if #army == 0 then
        endscreen.setMessage("Defeat!")
        _G.setState("end")
    else
        turn = "player"
    end
end

return battle
