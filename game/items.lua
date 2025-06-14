local items = {}

items.weapons = {
    { name = "Iron Sword", damage = 3, crit = 0, cost = 0 },
    { name = "Battle Axe", damage = 5, crit = -0.1, cost = 50 },
    { name = "Repeater", damage = 2, crit = 0.2, cost = 70 }
}

items.addons = {
    { name = "Shield", armor = 2, cost = 30 },
    { name = "Scope", crit = 0.3, cost = 40 },
    { name = "Runestone", magic = 1, cost = 50 }
}


return items
