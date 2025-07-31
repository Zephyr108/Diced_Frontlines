local player = require("game.core.player")
local enemiesData = require("game.data.enemies")
local Dice = require("game.data.dice")
local Roller = require("game.ui.roller")

local battle = {}

local allies = {}
local enemies = {}
local combatLog = {}
local currentTurn = "player"
local selectedAlly = 1
local selectedEnemy = 1

local function log(text)
    table.insert(combatLog, text)
end

local function rollAttack(attacker, defender, isPlayer)
    local die = Dice.getDiceForClass(player.getClass())
    local result = die:roll()
    Roller.setRoll(result, isPlayer)

    log(attacker.type .. " rolled: " .. result)

    if result == "miss" then
        log("Missed!")
    elseif result == "hit" then
        local damage = attacker.weapon.damage or 4
        defender.hp = defender.hp - damage
        log("Hit for " .. damage .. " dmg")
    elseif result == "crit" then
        local damage = (attacker.weapon.damage or 4) * 2
        defender.hp = defender.hp - damage
        log("Critical! " .. damage .. " dmg")
    elseif result == "block" then
        log("Blocked!")
    else
        log("Invalid die result: " .. tostring(result))
    end
end

local function performAttack()
    local attacker = allies[selectedAlly]
    local target = enemies[selectedEnemy]
    if attacker and target and attacker.hp > 0 and target.hp > 0 then
        rollAttack(attacker, target, true)
    end
    currentTurn = "enemy"
end

local function enemyTurn()
    for _, enemy in ipairs(enemies) do
        if enemy.hp > 0 then
            local target = allies[math.random(#allies)]
            if target.hp > 0 then
                rollAttack(enemy, target, false)
            end
        end
    end
    currentTurn = "player"
end

local function isBattleOver()
    local allEnemiesDead = true
    for _, enemy in ipairs(enemies) do
        if enemy.hp > 0 then allEnemiesDead = false break end
    end

    local allAlliesDead = true
    for _, ally in ipairs(allies) do
        if ally.hp > 0 then allAlliesDead = false break end
    end

    if allEnemiesDead then
        _G.setState("victory")
    elseif allAlliesDead then
        _G.setState("endscreen")
    end
end

function battle.load()
    allies = player.getArmy()
    enemies = {}
    combatLog = {}
    selectedAlly = 1
    selectedEnemy = 1
    currentTurn = "player"
    Roller.clear()

    local enemyList = { "Swordsman", "Brute", "Archer" }
    for _, enemyType in ipairs(enemyList) do
        local def = enemiesData.normal[enemyType]
        table.insert(enemies, {
            type = def.type,
            hp = def.baseHp,
            weapon = { damage = 4 }
        })
    end
end

function battle.update(dt)
end

function battle.draw()
    love.graphics.print("Logs:", 20, 20)
    for i, logLine in ipairs(combatLog) do
        love.graphics.print(logLine, 20, 40 + (i - 1) * 20)
    end

    love.graphics.print("Allies:", 200, 20)
    for i, ally in ipairs(allies) do
        local prefix = (i == selectedAlly) and "> " or "  "
        love.graphics.print(prefix .. ally.type .. " HP: " .. ally.hp, 200, 40 + (i - 1) * 30)
    end

    love.graphics.print("Enemies:", 500, 20)
    for i, enemy in ipairs(enemies) do
        local prefix = (i == selectedEnemy) and "> " or "  "
        love.graphics.print(prefix .. enemy.type .. " HP: " .. enemy.hp, 500, 40 + (i - 1) * 30)
    end

    Roller.draw(20, 400, 760, 400)
end

function battle.keypressed(key)
    if currentTurn == "player" then
        if key == "up" then
            selectedAlly = selectedAlly - 1
            if selectedAlly < 1 then selectedAlly = #allies end
        elseif key == "down" then
            selectedAlly = selectedAlly + 1
            if selectedAlly > #allies then selectedAlly = 1 end
        elseif key == "left" then
            selectedEnemy = selectedEnemy - 1
            if selectedEnemy < 1 then selectedEnemy = #enemies end
        elseif key == "right" then
            selectedEnemy = selectedEnemy + 1
            if selectedEnemy > #enemies then selectedEnemy = 1 end
        elseif key == "space" then
            performAttack()
        end
    else
        enemyTurn()
    end

    isBattleOver()
end

return battle
