local Battle = require('game.core.battle')
local M = {}
function M.enter() Battle.start(); Game.state='combat' end
function M.update(dt) Battle.update(dt) end
function M.draw() Battle.draw() end
function M.keypressed(key) Battle.keypressed(key) end
return M