local M = {}
function M.enter() end
function M.update(_) end
function M.draw()
  local W,H = love.graphics.getWidth(), love.graphics.getHeight()
  love.graphics.clear(0.08,0.09,0.12)
  love.graphics.printf('GAME OVER', 0, 120, W, 'center', 0, 1.8)
  love.graphics.printf(('Fights won: %d | Gold: %d'):format(Game.fightCount, Game.gold), 0, 200, W, 'center', 0, 1.2)
  love.graphics.printf('Press [Enter] to play again, or [Esc] to quit.', 0, 260, W, 'center')
end
function M.keypressed(key)
  if key=='return' or key=='kpenter' then Game.screen=require('game.screens.menu'); Game.screen.enter() elseif key=='escape' then love.event.quit() end
end
return M