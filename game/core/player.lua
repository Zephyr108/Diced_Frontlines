local utils = require('game.core.utils')
local M = {class=nil, name='Hero', hp=1, maxhp=1, atkBonus=0, defBonus=0, defDie=6, skillBonus=0, hasArtifact=false, attackDieOverride=nil, guard=0, critBonus=0}
function M.resetWithClass(c)
  M.class=c; M.maxhp=c.hp; M.hp=c.hp; M.atkBonus=c.baseAtk; M.defBonus=c.baseDef; M.defDie=6; M.skillBonus=0; M.hasArtifact=false; M.attackDieOverride=nil; M.guard=0; M.critBonus=0
end
function M.heal(n) M.hp = utils.clamp(M.hp + n, 0, M.maxhp) end
return M