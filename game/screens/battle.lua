local battle = {}
local player = require("game.core.player")
local units = require("game.data.units")
local endscreen = require("game.screens.endscreen")
local weapons = require("game.data.weapons")
local addons = require("game.data.addons")
local enemies = require("game.data.enemies")

local enemyArmy = {}
local selectedUnitIndex = 1
local selectedTargetIndex = 1
local turn = "player"
local battleLog = {}

function battle.load()
    battle.generateEnemies()

    local army = player.getArmy()
    for i, unit in ipairs(army) do
        local def = units.definitions[unit.type]
        unit.hp = def.hp
        unit.x = 1
        unit.y = i
    end

    selectedUnitIndex = 1
    selectedTargetIndex = 1
    turn = "player"
    battleLog = {}
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
end

function battle.draw()
    love.graphics.print("Turn: " .. turn, 100, 20)

    local army = player.getArmy()
    for i, unit in ipairs(army) do
        local tileSize = 48
        local x = 100
        local y = 100 + (i - 1) * 100

        love.graphics.rectangle("line", x, y, tileSize, tileSize)
        local weapon = unit.weapon or { name = "None", damage = 0 }
        love.graphics.print(unit.type .. " HP: " .. unit.hp .. " Dmg: " .. weapon.damage, x + 4, y + 4)

        if i == selectedUnitIndex and turn == "player" then
            love.graphics.rectangle("line", x - 2, y - 2, tileSize + 4, tileSize + 4)
        end
    end

    for i, unit in ipairs(enemyArmy) do
        local tileSize = 48
        local x = 400
        local y = 100 + (i - 1) * 100

        love.graphics.rectangle("line", x, y, tileSize, tileSize)
        love.graphics.print("Enemy HP: " .. unit.hp, x + 4, y + 4)

        if i == selectedTargetIndex and turn == "player" then
            love.graphics.rectangle("line", x - 2, y - 2, tileSize + 4, tileSize + 4)
        end
    end

    local logY = 400
    love.graphics.print("Battle Log:", 100, logY)
    for i = math.max(1, #battleLog - 5), #battleLog do
        love.graphics.print(battleLog[i], 100, logY + (i - math.max(1, #battleLog - 5) + 1) * 16)
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

        local weapon = attacker.weapon or weapons.Sword
        local addon = attacker.addon or {}

        local bonus = 0
        if addon.armor then bonus = bonus - 1 end
        if addon.crit then bonus = bonus + 1 end
        if addon.magic then bonus = bonus + 2 end

        local totalDamage = (weapon.damage or 0) + bonus
        target.hp = target.hp - totalDamage

        table.insert(battleLog, attacker.type .. " dealt " .. totalDamage .. " to " .. target.type)

        if target.hp <= 0 then
            table.insert(battleLog, target.type .. " was defeated")
            table.remove(enemyArmy, selectedTargetIndex)
            if selectedTargetIndex > #enemyArmy then
                selectedTargetIndex = #enemyArmy
            end
        end

        turn = "enemy"
        battle.processEnemyTurn()
    end
end

function battle.generateEnemies()
    local r = player.getRound()
    enemyArmy = {}

    local isBossRound = r % 5 == 0
    local pool = isBossRound and enemies.bosses or enemies.normal

    local keys = {}
    for k in pairs(pool) do table.insert(keys, k) end

    local count = isBossRound and 1 or 3

    for i = 1, count do
        local enemyName = keys[math.random(#keys)]
        local enemy = pool[enemyName]
        local unit = {
            type = enemy.type,
            hp = enemy.baseHp + r * 2,
            weapon = weapons[enemy.weapon],
            x = 5,
            y = i
        }
        table.insert(enemyArmy, unit)
    end

    if isBossRound then
        table.insert(battleLog, "⚠ Boss Round: " .. enemyArmy[1].type .. " appears!")
    end
end

function battle.processEnemyTurn()
    local army = player.getArmy()
    if #enemyArmy == 0 then return end
    if #army == 0 then
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

    table.insert(battleLog, enemy.type .. " dealt " .. totalDamage .. " to " .. target.type)

    if target.hp <= 0 then
        table.insert(battleLog, target.type .. " was defeated")
        for i, u in ipairs(army) do
            if u == target then
                local dead = table.remove(army, i)
                player.addFallen(dead)
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
