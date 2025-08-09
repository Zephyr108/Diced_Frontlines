local Player = require('game.core.player')
local M = {}
local function panel(x,y,w,h,title)
  love.graphics.setColor(1,1,1)
  love.graphics.rectangle('line', x,y,w,h)
  love.graphics.print(title, x+8,y+6)
end
function M.drawPlayer()
  local W,H = love.graphics.getWidth(), love.graphics.getHeight()
  panel(20,20,320,H-40,'Hero')
  love.graphics.print(('Class: %s'):format(Player.class and Player.class.name or '?'), 40, 50)
  love.graphics.print(('HP: %d/%d'):format(Player.hp, Player.maxhp), 40, 80)
  love.graphics.print(('Gold: %d'):format(Game.gold), 40, 110)
  love.graphics.print(('Attack die: d%d'):format(Player.attackDieOverride or (Player.class and Player.class.die or 6)), 40, 140)
  love.graphics.print(('Defense: d%d, bonus %d, shield %d'):format(Player.defDie or 6, Player.defBonus or 0, Player.guard or 0), 40, 170)
  love.graphics.print(('Reroll artifact: %s'):format(Player.hasArtifact and 'YES' or 'NO'), 40, 200)
end
function M.drawEnemy(e)
  local W,H = love.graphics.getWidth(), love.graphics.getHeight()
  panel(W-340,20,320,H-40,'Enemy')
  if not e then return end
  love.graphics.print(('%s%s'):format(e.name, e.boss and ' [BOSS]' or ''), W-320, 50)
  love.graphics.print(('Faction: %s'):format(e.faction.name), W-320, 80)
  love.graphics.print(('HP: %d/%d'):format(e.hp, e.maxhp), W-320, 110)
  love.graphics.print(('Attack: d%d, Defense: d%d%s'):format(e.atkDie, e.defDie, e.fortify and ' (+2 Fortify)' or ''), W-320, 140)
end
return M