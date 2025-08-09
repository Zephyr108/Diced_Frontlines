local Dice = require('game.core.dice')
local M = {}
function M.draw()
  local W,H = love.graphics.getWidth(), love.graphics.getHeight()
  love.graphics.setFont(Game.bigFont)
  local dieText = Dice.result and tostring(Dice.result) or '-'
  love.graphics.print(dieText, W/2 - Game.bigFont:getWidth(dieText)/2, H/2-40)
  love.graphics.setFont(Game.font)
end
return M