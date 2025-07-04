local battle = {}
local player = require("game.core.player")
local enemiesData = require("game.data.enemies")
local weapons = require("game.data.weapons")

local activeUnit = 1
local targetEnemy = 1
local enemies = {}
local log = {}

local isPlayerTurn = true

local function logMessage(msg)
    table.insert(log, msg)
    if #log > 6 then
        table.remove(log, 1)
    end
end

local function generateEnemies()
    enemies = {}
    local enemyTypes = enemiesData.normal
    for i = 1, 3 do
        local keys = {}
        for k in pairs(enemyTypes) do table.insert(keys, k) end
        local etype = keys[math.random(#keys)]
        local def = enemyTypes[etype]
        table.insert(enemies, {
            type = def.type,
            hp = def.baseHp,
            weapon = weapons[def.weapon]
        })
    end
end

local function performAttack(attacker, target)
    local die = player.getDie()
    local result = die:roll()
    local dmg = attacker.weapon.damage or 1

    if result == "miss" then
        logMessage(attacker.type .. " missed!")
    elseif result == "block" then
        logMessage(target.type .. " blocked!")
    elseif result == "crit" then
        target.hp = target.hp - dmg * 2
        logMessage(attacker.type .. " landed a CRIT for " .. (dmg * 2) .. "!")
    elseif result == "hit" then
        target.hp = target.hp - dmg
        logMessage(attacker.type .. " hit for " .. dmg .. " damage.")
    elseif result == "special" then
        target.hp = target.hp - dmg * 3
        logMessage(attacker.type .. " used SPECIAL! " .. (dmg * 3) .. " dmg!")
    end
end

function battle.load()
    activeUnit = 1
    targetEnemy = 1
    isPlayerTurn = true
    log = {}

    generateEnemies()
end

function battle.update(dt)
    -- nic tu nie ma
end

function battle.draw()
    love.graphics.print("BATTLE", 20, 20)

    -- Player Army
    local army = player.getArmy()
    for i, unit in ipairs(army) do
        local y = 60 + i * 40
        local prefix = (i == activeUnit) and "> " or "  "
        love.graphics.print(prefix .. unit.type .. " HP: " .. unit.hp, 20, y)
    end

    -- Enemies
    for i, e in ipairs(enemies) do
        local y = 60 + i * 40
        local prefix = (i == targetEnemy) and "> " or "  "
        love.graphics.print(prefix .. e.type .. " HP: " .. e.hp, 300, y)
    end

    -- Log
    for i, msg in ipairs(log) do
        love.graphics.print(msg, 20, 250 + i * 20)
    end

    love.graphics.print("Turn: " .. (isPlayerTurn and "Player" or "Enemy"), 20, 230)
    love.graphics.print("[↑↓] Select unit [←→] Select enemy [Space] Attack", 20, 400)
end

function battle.keypressed(key)
    local army = player.getArmy()

    if isPlayerTurn then
        if key == "up" then
            activeUnit = (activeUnit - 2) % #army + 1
        elseif key == "down" then
            activeUnit = (activeUnit) % #army + 1
        elseif key == "left" then
            targetEnemy = (targetEnemy - 2) % #enemies + 1
        elseif key == "right" then
            targetEnemy = (targetEnemy) % #enemies + 1
        elseif key == "space" then
            local attacker = army[activeUnit]
            local target = enemies[targetEnemy]
            if attacker and target and attacker.hp > 0 and target.hp > 0 then
                performAttack(attacker, target)
                if target.hp <= 0 then
                    logMessage(target.type .. " has been defeated!")
                end
                isPlayerTurn = false
            end
        end
    else
        -- Enemy Turn (one enemy attacks)
        for _, enemy in ipairs(enemies) do
            if enemy.hp > 0 then
                local target = nil
                for _, u in ipairs(army) do
                    if u.hp > 0 then
                        target = u
                        break
                    end
                end
                if target then
                    performAttack(enemy, target)
                    if target.hp <= 0 then
                        logMessage(target.type .. " has fallen!")
                        player.addFallen(target)
                    end
                end
                break
            end
        end
        isPlayerTurn = true
    end

    -- Check end of battle
    local allEnemiesDead = true
    for _, e in ipairs(enemies) do
        if e.hp > 0 then
            allEnemiesDead = false
            break
        end
    end

    local allAlliesDead = true
    for _, u in ipairs(army) do
        if u.hp > 0 then
            allAlliesDead = false
            break
        end
    end

    if allEnemiesDead then
        logMessage("Victory! Press Enter...")
    elseif allAlliesDead then
        logMessage("Defeat! Press Enter...")
    end

    if key == "return" then
        if allEnemiesDead then
            player.addMoney(50)
            player.nextRound()
            _G.setState("shop")
        elseif allAlliesDead then
            _G.setState("endscreen")
        end
    end
end

return battle
