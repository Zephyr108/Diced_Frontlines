local Shop = require('game.core.items')
local M = {}
function M.enter() Game.state='shop'; Shop.rollShop(); 
  Game:pushLog('— SHOP — Choose [1-9], [Space] to continue') 
end
function M.update(_) end
function M.draw()
  local W,H = love.graphics.getWidth(), love.graphics.getHeight()
  love.graphics.clear(0.08,0.09,0.12)
  love.graphics.printf('SHOP', 0, 40, W, 'center', 0, 1.6)
  love.graphics.printf(('Gold: %d | After fight: %d'):format(Game.gold, Game.fightCount), 0, 84, W, 'center')
  local inv = Shop.shopInventory
  for i,item in ipairs(inv) do
    local affordable = Game.gold>=item.cost
    love.graphics.setColor(affordable and 1 or 0.7, affordable and 1 or 0.7, affordable and 1 or 0.7)
    love.graphics.print(('[%d] %s – %d gold | %s'):format(i, item.name, item.cost, item.desc), 100, 140 + (i-1)*28)
  end
  love.graphics.setColor(1,1,1)
  love.graphics.print('[Space] Continue to next fight', 100, 140 + (#inv)*28 + 20)
end
function M.keypressed(key)
  if key>='1' and key<='9' then Shop.buy(tonumber(key))
  elseif key=='space' then Game.screen = require('game.screens.battle'); Game.screen.enter() end
end
return M