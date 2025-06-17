local skills = {
    DoubleStrike = {
        name = "Double Strike",
        cooldown = 2,
        effect = function(attacker, target)
            return attacker.weapon.damage * 2
        end
    },
    Heal = {
        name = "Heal",
        cooldown = 3,
        effect = function(user)
            user.hp = user.hp + 5
        end
    },
    Stun = {
        name = "Stun",
        cooldown = 4,
        effect = function(attacker, target)
            target.stunned = true
        end
    }
}

return skills
