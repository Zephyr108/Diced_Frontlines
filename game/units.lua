local units = {}

units.definitions = {
    Swordsman = {
        hp = 10,
        damage = 3,
        sprite = nil -- dodać grafikę później
    },
    Gunner = {
        hp = 6,
        damage = 5,
        sprite = nil
    }
}

function units.create(typeName, x, y)
    local def = units.definitions[typeName]
    return {
        type = typeName,
        hp = def.hp,
        damage = def.damage,
        x = x,
        y = y
    }
end

return units
