local utils = require('game.core.utils')
local Factions = require('game.data.factions')
local M = {current=nil}
local function rollEnemy(fightCount)
  local isBoss = (fightCount>0 and fightCount%5==0)
  local faction = utils.choice(Factions)
  local e
  if isBoss then e = utils.deepcopy(faction.boss); e.boss=true else e = utils.deepcopy(utils.choice(faction.enemies)) end
  e.faction=faction; e.maxhp=e.hp; e.igniteTimer=0; e.fortify=false; e.bossCycle=0
  return e
end
function M.newForFight() M.current = rollEnemy(Game.fightCount) return M.current end
return M