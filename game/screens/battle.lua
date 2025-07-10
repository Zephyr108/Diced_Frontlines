local player = require("game.core.player")
local enemies = require("game.data.enemies")
local weapons = require("game.data.weapons")
local dice = require("game.data.dice")
local roller = require("game.ui.roller")

local battle = {}

local playerUnits = {}
local enemyUnits = {}
local selectedPlayerUnit = 1
local selectedEnemyUnit = 1
local turn = "player"
local logs = {}

local function log(text)
    table.insert(logs, text)
    if #logs > 10 then
        table.remove(logs, 1)
    end
end

local function rollAttack(attacker, defender, attackerType)
    local die = dice.getDiceForClass(attacker.class or "Default")
    local result = die:roll()

    -- zapisz rzut do UI
    roller.setRoll(attackerType, result)

    local damage = 0
    if result == "MISS" then
        log((attackerType and "Player" or "Enemy") .. " missed!")
        return
    elseif result == "CRIT" then
        damage = (attacker.weapon and attacker.weapon.damage or 1) * 2
        log((attackerType and "Player" or "Enemy") .. " landed a CRITICAL HIT!")
    else
        damage = (attacker.weapon and attacker.weapon.damage or 1) + tonumber(result)
    end

    defender.hp = defender.hp - damage
    log((attackerType and "Player" or "Enemy") .. " dealt " .. damage .. " damage to " .. (defender.class or "enemy") .. "!")
end


local function nextTurn()
    if turn == "player" then
        turn = "enemy"
    else
        turn = "player"
    end
end

local function isTeamAlive(team)
    for _, unit in ipairs(team) do
        if unit.hp > 0 then return true end
    end
    return false
end

local function getFirstAlive(team)
    for i, unit in ipairs(team) do
        if unit.hp > 0 then return i end
    end
    return nil
end

function battle.load()
    logs = {}
    roller.clear()

    local class = player.getClass()
    playerUnits = {}
    for _, unit in ipairs(player.getArmy()) do
        table.insert(playerUnits, {
            class = class,
            hp = unit.hp,
            weapon = unit.weapon,
            addon = unit.addon,
        })
    end

    enemyUnits = {}
    for i = 1, 3 do
        local keys = {}
        for k in pairs(enemies.normal) do table.insert(keys, k) end
        local name = keys[math.random(#keys)]
        local def = enemies.normal[name]
        table.insert(enemyUnits, {
            class = name,
            hp = def.baseHp,
            weapon = weapons[def.weapon]
        })
    end

    selectedPlayerUnit = getFirstAlive(playerUnits) or 1
    selectedEnemyUnit = getFirstAlive(enemyUnits) or 1
    turn = "player"
end

function battle.update(dt)
    roller.update(dt)
end

function battle.draw()
    love.graphics.print("Battle Phase - Turn: " .. turn, 50, 20)

    for i, unit in ipairs(playerUnits) do
        local y = 60 + i * 40
        local prefix = (i == selectedPlayerUnit and turn == "player") and "> " or "  "
        love.graphics.print(prefix .. unit.class .. " HP: " .. unit.hp, 50, y)
    end

    for i, unit in ipairs(enemyUnits) do
        local y = 60 + i * 40
        local prefix = (i == selectedEnemyUnit and turn == "enemy") and "> " or "  "
        love.graphics.print(prefix .. unit.class .. " HP: " .. unit.hp, 400, y)
    end

    love.graphics.print("Logs:", 50, 300)
    for i, msg in ipairs(logs) do
        love.graphics.print(msg, 50, 320 + i * 15)
    end

    roller.draw()
end

function battle.keypressed(key)
    if turn == "player" then
        if key == "up" then
            selectedPlayerUnit = (selectedPlayerUnit - 2) % #playerUnits + 1
        elseif key == "down" then
            selectedPlayerUnit = (selectedPlayerUnit) % #playerUnits + 1
        elseif key == "left" then
            selectedEnemyUnit = (selectedEnemyUnit - 2) % #enemyUnits + 1
        elseif key == "right" then
            selectedEnemyUnit = (selectedEnemyUnit) % #enemyUnits + 1
        elseif key == "space" then
            local attacker = playerUnits[selectedPlayerUnit]
            local defender = enemyUnits[selectedEnemyUnit]
            if attacker.hp > 0 and defender.hp > 0 then
                rollAttack(attacker, defender, true)
                if not isTeamAlive(enemyUnits) then
                    _G.setState("victory")
                    return
                end
                nextTurn()
            end
        end
    elseif turn == "enemy" then
        local ai = enemyUnits[selectedEnemyUnit]
        local targetIndex = getFirstAlive(playerUnits)
        if ai and targetIndex then
            local target = playerUnits[targetIndex]
            rollAttack(ai, target, false)
            if not isTeamAlive(playerUnits) then
                _G.setState("defeat")
                return
            end
            nextTurn()
        end
    end
end

return battle
