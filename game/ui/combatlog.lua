local M = { offset = 0 }

local RESERVE_BOTTOM = 28
local lineH, pad = 14, 6

local function box()
  local W, H = love.graphics.getWidth(), love.graphics.getHeight()
  local w = W - 720
  local h = 200 - RESERVE_BOTTOM
  local x = 360
  local y = H - 220
  return x, y, w, h
end

local function visibleLines()
  local _,_,_,h = box()
  return math.max(1, math.floor((h - pad*2) / lineH))
end

local function maxOffset()
  -- offset liczymy „od dołu” – ile linii w górę od dolnego, najnowszego końca
  return math.max(0, #Game.log - visibleLines())
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
  if     key == "up"       then M.scroll(1)
  elseif key == "down"     then M.scroll(-1)
  elseif key == "pageup"   then M.scroll( visibleLines())
  elseif key == "pagedown" then M.scroll(-visibleLines())
  elseif key == "home"     then M.offset = maxOffset()  -- do samego początku (najstarsze)
  elseif key == "end"      then M.offset = 0            -- na sam dół (najnowsze)
  end
end

-- udostępniamy położenie boxa do rysowania hintów poniżej
function M.bounds()
  return box()
end

function M.draw()
  local x,y,w,h = box()

  -- ramka
  love.graphics.setColor(1,1,1)
  love.graphics.rectangle("line", x, y, w, h)

  -- clipping (zaokrąglamy współrzędne, żeby uniknąć „półpikselowego” klipu)
  local sx, sy, sw, sh = math.floor(x+1), math.floor(y+1), math.floor(w-2), math.floor(h-2)
  love.graphics.setScissor(sx, sy, sw, sh)

  local total = #Game.log
  local vis   = visibleLines()

  -- indeks pierwszej widocznej linii
  -- (0 offset = patrzymy na dół listy: (#-vis+1)..# )
  local first = math.max(1, total - vis + 1 - M.offset)
  local last  = math.min(total, first + vis - 1)

  local drawY = y + pad
  for i = first, last do
    love.graphics.print(Game.log[i], x + pad, drawY)
    drawY = drawY + lineH
  end

  love.graphics.setScissor()
end

return M
