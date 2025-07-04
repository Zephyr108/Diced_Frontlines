local player = {}

local army = {}
local money = 100
local round = 1
local lastReward = 0
local fallen = {}
local selectedClass = "blacksmith" -- domyślnie

function player.addUnit(unit)
    table.insert(army, unit)
end

function player.getArmy()
    return army
end

function player.clearArmy()
    army = {}
end

function player.getMoney()
    return money
end

function player.addMoney(amount)
    money = money + amount
end

function player.spendMoney(amount)
    if money >= amount then
        money = money - amount
        return true
    end
    return false
end

function player.getRound()
    return round
end

function player.nextRound()
    round = round + 1
end

function player.setLastReward(r)
    lastReward = r
end

function player.getLastReward()
    return lastReward
end

function player.addFallen(unit)
    table.insert(fallen, unit)
end

function player.getFallen()
    return fallen
end

function player.resetFallen()
    fallen = {}
end

function player.revive(index)
    local unit = table.remove(fallen, index)
    if unit then
        unit.hp = 10 -- przykładowe bazowe HP przy wskrzeszeniu
        table.insert(army, unit)
    end
end

-- NOWE: Klasa gracza i dostęp do kostki

function player.setClass(classId)
    selectedClass = classId
end

function player.getClass()
    return selectedClass
end

function player.getDie()
    local dice = require("game.data.dice")
    return dice[selectedClass] or dice.blacksmith
end

return player
