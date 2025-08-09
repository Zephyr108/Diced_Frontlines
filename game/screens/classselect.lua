local Player  = require("game.core.player")
local Classes = require("game.data.classes")

local M = {}

function M.enter()
  Game.state = "classselect"
end

function M.update(_) end

function M.draw()
  local W, H = love.graphics.getWidth(), love.graphics.getHeight()
  love.graphics.clear(0.08,0.09,0.12)
  love.graphics.printf("CHOOSE CLASS", 0, 60, W, "center", 0, 1.6)
  love.graphics.printf("Press 1–5 to select, Esc to go back", 0, 100, W, "center")

  for i, c in ipairs(Classes) do
    local line = ("[%d] %s – die d%d | HP %d | Atk+%d Def+%d | Skill: %s")
      :format(i, c.name, c.die, c.hp, c.baseAtk, c.baseDef, c.skill)
    love.graphics.print(line, 100, 140 + (i-1)*28)
  end
end

function M.keypressed(key)
  if key >= "1" and key <= "5" then
    local i = tonumber(key)
    local c = Classes[i]
    if c then
      Player.resetWithClass(c)
      Game.gold, Game.fightCount = 20, 0
      Game.log = {}                          -- świeży log na start
      Game:pushLog(("Class chosen: %s (die d%d)"):format(c.name, c.die))
      Game.screen = require("game.screens.battle")
      Game.screen.enter()
    end
  elseif key == "escape" then
    Game.screen = require("game.screens.menu")
    Game.screen.enter()
  end
end

return M
