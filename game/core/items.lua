local utils = require('game.core.utils')
local Player = require('game.core.player')
local DataItems = require('game.data.items')
local M = {shopInventory={}}
function M.rollShop()
  M.shopInventory = {}
  local buckets = {DataItems.weapon, DataItems.armor, DataItems.trinket, DataItems.consumable, DataItems.dice}
  for _,b in ipairs(buckets) do table.insert(M.shopInventory, utils.deepcopy(utils.choice(b))) end
  table.insert(M.shopInventory, {id='potion_discount', name='Potion (promo)', desc='+8 HP.', cost=12, effect=function(p) p.hp = math.min(p.maxhp, p.hp+8) end})
  return M.shopInventory
end
function M.buy(idx)
  local it = M.shopInventory[idx]
  if not it then Game:pushLog('Invalid selection.') return false end
  if Game.gold < it.cost then Game:pushLog('Not enough gold.') return false end
  Game.gold = Game.gold - it.cost
  it.effect(Player)
  Game:pushLog('Purchased: '..it.name)
  require("game.core.save").saveGame()
  return true
end
return M