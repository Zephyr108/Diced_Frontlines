local function roll(die)
    local sides = die.sides
    local index = math.random(1, #sides)
    return sides[index]
end

local dice = {}

dice.blacksmith = {
    name = "Forge Die",
    sides = { "hit", "hit", "crit", "block", "miss", "special" },
    roll = function(self) return roll(self) end
}

dice.gunsmith = {
    name = "Precision Die",
    sides = { "hit", "crit", "hit", "miss", "crit", "miss" },
    roll = function(self) return roll(self) end
}

dice.alchemist = {
    name = "Chaos Die",
    sides = { "crit", "miss", "special", "hit", "block", "miss" },
    roll = function(self) return roll(self) end
}

function dice.getDiceForClass(class)
    if class == "Blacksmith" then
        return dice.blacksmith
    elseif class == "Gunsmith" then
        return dice.gunsmith
    elseif class == "Alchemist" then
        return dice.alchemist
    else
        return dice.blacksmith -- domyślnie
    end
end

return dice
