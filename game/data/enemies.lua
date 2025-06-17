local enemies = {
    normal = {
        Swordsman = {
            type = "Swordsman",
            baseHp = 5,
            weapon = "Axe"
        },
        Archer = {
            type = "Archer",
            baseHp = 3,
            weapon = "Dagger"
        },
        Brute = {
            type = "Brute",
            baseHp = 8,
            weapon = "Mace"
        }
    },

    bosses = {
        Giant = {
            type = "Giant",
            baseHp = 40,
            weapon = "Mace"
        },
        Shadow = {
            type = "Shadow",
            baseHp = 25,
            weapon = "Dagger"
        },
        Overlord = {
            type = "Overlord",
            baseHp = 35,
            weapon = "Sword"
        }
    }
}

return enemies
