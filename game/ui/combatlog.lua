local M = { offset = 0 }  -- 0 = pokazuj najnowsze (góra listy)

-- parametry boxa
local function box()
  local W,H = love.graphics.getWidth(), love.graphics.getHeight()
  return 360, H-220, W-720, 200
end

local lineH, pad = 14, 6

local function visibleLines()
  local _,_,_,h = box()
  return math.max(1, math.floor((h - pad*2) / lineH))
end

local function maxOffset()
  local vis = visibleLines()
  local total = #Game.log
  return math.max(0, total - vis)
end

local function clampOffset()
  M.offset = math.max(0, math.min(M.offset, maxOffset()))
end

function M.reset()
  M.offset = 0
end

function M.scroll(delta)
  M.offset = M.offset + delta
  clampOffset()
end

function M.handleKey(key)
  if key == "up"       then M.scroll( 1)
  elseif key == "down" then M.scroll(-1)
  elseif key == "pageup"   then M.scroll( visibleLines())
  elseif key == "pagedown" then M.scroll(-visibleLines())
  elseif key == "home"     then M.offset = maxOffset()
  elseif key == "end"      then M.offset = 0
  end
end

function M.draw()
  local x,y,w,h = box()

  -- ramka
  love.graphics.setColor(1,1,1)
  love.graphics.rectangle("line", x, y, w, h)

  -- clipping
  love.graphics.setScissor(x+1, y+1, w-2, h-2)

  -- oblicz zakres (pamiętaj: Game.log[1] = najnowszy)
  local vis = visibleLines()
  local startIndex = 1 + M.offset
  local endIndex   = math.min(#Game.log, startIndex + vis - 1)

  for i = startIndex, endIndex do
    local lineY = y + pad + (i - startIndex) * lineH
    love.graphics.print(Game.log[i], x + pad, lineY)
  end

  love.graphics.setScissor()

  -- mały wskaźnik przewijania
  if maxOffset() > 0 then
    local info = string.format("↑/↓ scroll  PgUp/PgDn  Home/End  (%d/%d)", (startIndex-1)+1, #Game.log)
    love.graphics.printf(info, x, y+h-16, w, "right")
  end
end

return M