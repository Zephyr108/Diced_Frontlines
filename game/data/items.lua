local M = {}
M.weapon = {
  {id='sword', name='Sword', desc='+2 to attack roll.', cost=20, effect=function(p) p.atkBonus=(p.atkBonus or 0)+2 end},
  {id='staff', name='Mage Staff', desc='Skill +2.', cost=20, effect=function(p) p.skillBonus=(p.skillBonus or 0)+2 end},
  {id='dagger', name='Dagger', desc='If roll=MAX: +3 damage.', cost=18, effect=function(p) p.critBonus=(p.critBonus or 0)+3 end},
}
M.armor = {
  {id='shield', name='Shield', desc='+1 defense bonus.', cost=15, effect=function(p) p.defBonus=(p.defBonus or 0)+1 end},
  {id='armor',  name='Armor',  desc='Defense roll d10 (instead of d6).', cost=25, effect=function(p) p.defDie=10 end},
}
M.trinket = {
  {id='artifact', name='Fate Artifact', desc='One reroll per fight.', cost=30, effect=function(p) p.hasArtifact=true end},
}
M.consumable = {
  {id='potion', name='Healing Potion', desc='Instant +8 HP.', cost=15, effect=function(p) p.hp = math.min(p.maxhp, p.hp+8) end},
}
M.dice = {
  {id='die_d10', name='New attack die d10', desc='Replaces class die.', cost=22, effect=function(p) p.attackDieOverride=10 end},
  {id='die_d16', name='New attack die d16', desc='Replaces class die.', cost=35, effect=function(p) p.attackDieOverride=16 end},
}
return M