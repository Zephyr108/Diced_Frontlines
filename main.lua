local Save = require("game.core.save")
Save.loadSettings()
Save.applySettings()

local Screen = require('game.screens.menu')
_G.Game = {
  state = 'menu',
  screen = nil,
  log = {},
  gold = 0,
  fightCount = 0,
  font = nil,
  bigFont = nil,
}

function Game:pushLog(msg)
  local text = tostring(msg):gsub("^\n+", "")

  for line in text:gmatch("([^\n]+)") do
    table.insert(self.log, line)
  end

  local CAP = 500
  while #self.log > CAP do
    table.remove(self.log, 1)
  end
end

function love.load()
  love.window.setTitle('Diced Frontlines')
  -- Load a font with full Latin support for clean diacritics if needed later
  local function tryFont(path, size) if love.filesystem.getInfo(path) then return love.graphics.newFont(path, size) end end
  Game.font    = tryFont('assets/fonts/NotoSans-Regular.ttf', 16)
              or tryFont('assets/fonts/DejaVuSans.ttf', 16)
              or love.graphics.newFont(16)
  Game.bigFont = tryFont('assets/fonts/NotoSans-Regular.ttf', 56)
              or tryFont('assets/fonts/DejaVuSans.ttf', 56)
              or love.graphics.newFont(56)
  love.graphics.setFont(Game.font)
  Game.screen = require('game.screens.menu')
  Game.screen.enter()
end

function love.update(dt)
  if Game.screen and Game.screen.update then Game.screen.update(dt) end
end

function love.draw()
  if Game.screen and Game.screen.draw then Game.screen.draw() end
end

function love.keypressed(key)
  if Game.screen and Game.screen.keypressed then Game.screen.keypressed(key) end
end