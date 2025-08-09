local Player  = require("game.core.player")
local Classes = require("game.data.classes")
local Save    = require("game.core.save")

local M = {}
local entries = { "New Game", "Continue", "Settings", "Quit" }
local idx = 1

local function hasContinue()
  return Save.hasSave()
end

function M.enter()
  Game.state = "menu"
  idx = 1
end

function M.update(_) end

function M.draw()
  local W, H = love.graphics.getWidth(), love.graphics.getHeight()
  love.graphics.clear(0.08, 0.09, 0.12)
  love.graphics.setColor(1,1,1)
  love.graphics.printf("DICED FRONTLINES", 0, 40, W, "center", 0, 1.6)
  love.graphics.printf("Use arrows up/down and Enter", 0, 90, W, "center")

  for i, label in ipairs(entries) do
    local disabled = (label == "Continue" and not hasContinue())
    local y = 140 + (i-1)*36
    if i == idx then love.graphics.rectangle("line", W/2-160, y-4, 320, 28) end
    love.graphics.setColor(disabled and 0.6 or 1, disabled and 0.6 or 1, disabled and 0.6 or 1)
    love.graphics.printf(label, 0, y, W, "center")
    love.graphics.setColor(1,1,1)
  end
end

local function startNewGame()
  Game.screen = require("game.screens.classselect")
  Game.screen.enter()
end

function M.keypressed(key)
  if key == "up" then
    idx = (idx-2) % #entries + 1
  elseif key == "down" then
    idx = (idx) % #entries + 1
  elseif key == "return" or key == "kpenter" then
    local choice = entries[idx]
    if choice == "New Game" then
      startNewGame()
    elseif choice == "Continue" then
      if hasContinue() then
        Save.loadGame()
        Game.screen = require("game.screens.battle")
        Game.screen.enter()
      end
    elseif choice == "Settings" then
      Game.screen = require("game.screens.settings")
      Game.screen.enter()
    elseif choice == "Quit" then
      love.event.quit()
    end
  elseif key == "escape" then
    love.event.quit()
  end
end

return M