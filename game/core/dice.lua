local M = {isRolling=false, t=0, duration=0.9, result=nil, sides=6}
function M.start(sides) M.isRolling=true; M.t=0; M.duration=0.9; M.sides=sides; M.result=love.math.random(1,sides) end
function M.update(dt)
  if not M.isRolling then return end
  M.t=M.t+dt
  if M.t < M.duration then if M.t % 0.05 < dt then M.result=love.math.random(1,M.sides) end else M.isRolling=false end
end
return M