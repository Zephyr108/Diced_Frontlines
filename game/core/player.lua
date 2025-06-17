local player = {
    class = "None",
    army = {}
}

function player.getClass()
    return player.class
end

function player.setClass(className)
    player.class = className
    player.generateNewArmy()
end

function player.generateNewArmy()
    local units = require("game.units")
    player.army = {}

    if player.class == "Blacksmith" then
        table.insert(player.army, units.create("Swordsman", 1, 1))
        table.insert(player.army, units.create("Swordsman", 1, 2))
        table.insert(player.army, units.create("Swordsman", 1, 3))
    elseif player.class == "Gunsmith" then
        table.insert(player.army, units.create("Gunner", 1, 1))
        table.insert(player.army, units.create("Gunner", 1, 2))
        table.insert(player.army, units.create("Gunner", 1, 3))
    end
end


function player.getArmy()
    return player.army
end

function player.addUnit(unit)
    table.insert(player.army, unit)
end

function player.clearArmy()
    player.army = {}
end

player.money = 0

function player.getMoney()
    return player.money
end

function player.addMoney(amount)
    player.money = player.money + amount
end

function player.spendMoney(amount)
    if player.money >= amount then
        player.money = player.money - amount
        return true
    else
        return false
    end
end

player.round = 1

function player.getRound()
    return player.round
end

function player.nextRound()
    player.round = player.round + 1
end

function player.resetRound()
    player.round = 1
end

local fallenUnits = {}

function player.getFallen()
    return fallenUnits
end

function player.addFallen(unit)
    table.insert(fallenUnits, unit)
end

function player.revive(index)
    local revived = table.remove(fallenUnits, index)
    if revived then
        revived.hp = require("game.data.units").definitions[revived.type].hp
        local army = player.getArmy()
        table.insert(army, revived)
        return true
    end
    return false
end

function player.resetFallen()
    fallenUnits = {}
end

return player
