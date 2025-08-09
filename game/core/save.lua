local M = { settings = { fullscreen = false } }

local function serialize(v)
  local t = type(v)
  if t == "string"  then return string.format("%q", v)
  elseif t == "number" or t == "boolean" then return tostring(v)
  elseif t == "table" then
    local parts = {"{"}
    for k,val in pairs(v) do
      table.insert(parts, string.format("[%q]=%s,", k, serialize(val)))
    end
    table.insert(parts, "}")
    return table.concat(parts)
  end
  return "nil"
end

local function writeLua(path, tableValue)  love.filesystem.write(path, "return " .. serialize(tableValue)) end
local function readLua(path)
  if not love.filesystem.getInfo(path) then return nil end
  local chunk = love.filesystem.load(path)
  local ok, data = pcall(chunk)
  return ok and data or nil
end

-- SETTINGS
function M.loadSettings()
  local t = readLua("settings.lua")
  if type(t) == "table" then M.settings = t end
end
function M.saveSettings() writeLua("settings.lua", M.settings) end
function M.applySettings()
  love.window.setMode(0, 0, { fullscreen = M.settings.fullscreen, fullscreentype = "desktop", resizable = true })
end
function M.toggleFullscreen()
  M.settings.fullscreen = not M.settings.fullscreen
  M.applySettings(); M.saveSettings()
end

-- SAVEGAME (simple snapshot of run)
local Player = require("game.core.player")
function M.hasSave() return love.filesystem.getInfo("save.lua") ~= nil end
function M.saveGame()
  local data = {
    gold = Game.gold,
    fightCount = Game.fightCount,
    player = {
      class = Player.class and Player.class.id or nil,
      hp = Player.hp, maxhp = Player.maxhp,
      atkBonus = Player.atkBonus, defBonus = Player.defBonus, defDie = Player.defDie,
      skillBonus = Player.skillBonus, hasArtifact = Player.hasArtifact,
      attackDieOverride = Player.attackDieOverride, guard = Player.guard, critBonus = Player.critBonus
    }
  }
  writeLua("save.lua", data)
end
function M.loadGame()
  local t = readLua("save.lua"); if type(t) ~= "table" then return false end
  local Classes = require("game.data.classes")
  if t.player and t.player.class then
    for _,c in ipairs(Classes) do if c.id == t.player.class then require("game.core.player").resetWithClass(c) end end
  end
  Game.gold = t.gold or 0
  Game.fightCount = t.fightCount or 0
  local P = require("game.core.player")
  for k,v in pairs(t.player or {}) do P[k] = v end
  return true
end

return M
