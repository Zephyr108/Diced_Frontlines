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

return player
