local Save = require("game.core.save")
local M = {}
local idx, items = 1, { "Fullscreen", "Back" }

function M.enter() Game.state = "settings" end
function M.update(_) end
function M.draw()
  local W,H = love.graphics.getWidth(), love.graphics.getHeight()
  love.graphics.clear(0.08,0.09,0.12)
  love.graphics.printf("SETTINGS", 0, 40, W, "center", 0, 1.6)
  local lines = { ("Fullscreen: %s"):format(Save.settings.fullscreen and "ON" or "OFF"), "Back" }
  for i,txt in ipairs(lines) do
    local y = 140 + (i-1)*36
    if i==idx then love.graphics.rectangle("line", W/2-200, y-4, 400, 28) end
    love.graphics.printf(txt, 0, y, W, "center")
  end
  love.graphics.printf("Enter to select • Space toggles Fullscreen • Esc to back", 0, H-40, W, "center")
end
function M.keypressed(key)
  if key=="up" then idx=(idx-2)%#items+1
  elseif key=="down" then idx=(idx)%#items+1
  elseif key=="space" and idx==1 then Save.toggleFullscreen()
  elseif key=="return" or key=="kpenter" then
    if idx==1 then Save.toggleFullscreen() else Game.screen=require("game.screens.menu"); Game.screen.enter() end
  elseif key=="escape" then Game.screen=require("game.screens.menu"); Game.screen.enter() end
end
return M
