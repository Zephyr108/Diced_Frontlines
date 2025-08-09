local utils = require('game.core.utils')
local Player = require('game.core.player')
local EnemyMod = require('game.core.enemy')
local Dice = require('game.core.dice')
local M = {turn='player', awaitingRoll=false, action=nil, tempRoll=nil, enemyActTimer=0, igniteApplied=false}
local function playerDefenseDie() return Player.defDie or 6 end
local function enemyDefenseDie(e) local extra=(e.fortify and 2 or 0) return (e.defDie or 6), extra end
local function applyDamage(target,dmg) target.hp = utils.clamp(target.hp - math.max(0, math.floor(dmg)), 0, target.maxhp) end
local function playerAttackValue() local die=Player.attackDieOverride or Player.class.die; return die, Player.atkBonus end

local function performPlayerResolved(action, roll, e)
  local msg
  if action=='attack' then
    local sides, atkBonus = playerAttackValue()
    local dmg = roll + atkBonus
    if Player.critBonus>0 and roll==sides then dmg = dmg + Player.critBonus end
    local defDie, extra = enemyDefenseDie(e)
    local defRoll = love.math.random(1, defDie) + (extra or 0)
    local final = math.max(0, dmg - defRoll)
    applyDamage(e, final)
    msg = ('Attack: roll %dd -> %d +%d vs Defense %dd -> %d => %d dmg.'):format(sides, roll, atkBonus, defDie, defRoll, final)
    if e.faction.id=='undead' and love.math.random()<0.10 and e.hp==0 and not e.boss then e.hp=1; msg = msg .. ' Undead resurrect at 1 HP!' end
  elseif action=='defend' then
    local defDie = playerDefenseDie(); Player.guard = roll + Player.defBonus
    msg = ('Defend: roll %dd -> %d +%d. Shield %d.'):format(defDie, roll, Player.defBonus, Player.guard)
  elseif action=='skill' then
    local extra = Player.skillBonus or 0
    if     Player.class.id=='warrior' then
      local r1,r2 = love.math.random(1,12), love.math.random(1,12)
      local r = math.max(r1,r2)
      local defDie, extraDef = enemyDefenseDie(e)
      local defRoll = love.math.random(1,defDie) + (extraDef or 0)
      local dmg = r + 2 + extra
      local final = math.max(0, dmg - defRoll); applyDamage(e, final)
      msg = ('Power Strike: %d/%d -> %d +2+%d vs DEF %dd=%d => %d dmg'):format(r1,r2,r,extra,defDie,defRoll,final)
    elseif Player.class.id=='mage' then
      local dmg = roll + 2 + extra; applyDamage(e, dmg); msg = ('Fireball: %d +2+%d => %d dmg (ignores DEF)'):format(roll, extra, dmg)
      if e.faction.id=='demon' and not M.igniteApplied then M.igniteApplied=true; e.hp = utils.clamp(e.hp + 2, 0, e.maxhp); msg = msg .. ' (Demons resist: -2 dmg)' end
    elseif Player.class.id=='rogue' then
      local sides, atkBonus = playerAttackValue(); local base = roll + atkBonus + extra
      local mult = (roll>=5) and 2 or 1
      local defDie, extraDef = enemyDefenseDie(e)
      local defRoll = love.math.random(1,defDie) + (extraDef or 0)
      local final = math.max(0, base*mult - defRoll); applyDamage(e, final)
      msg = ('Backstab: %d +%d+%d x%d vs DEF %dd=%d => %d dmg'):format(roll, atkBonus, extra, mult, defDie, defRoll, final)
    elseif Player.class.id=='barb' then
      local base = roll; if roll>=15 then base = base*2 end
      local defDie, extraDef = enemyDefenseDie(e)
      local defRoll = love.math.random(1,defDie) + (extraDef or 0)
      local final = math.max(0, base + extra - defRoll); applyDamage(e, final)
      msg = ('Rage: d20=%d%s +%d vs DEF %dd=%d => %d dmg'):format(roll, (roll>=15 and ' (x2)' or ''), extra, defDie, defRoll, final)
    elseif Player.class.id=='monk' then
      local heal = 2 + extra; Player.heal(heal); Player.guard = Player.guard + 1
      msg = ('Calm: set result=1, heal %d HP and +1 shield (total %d).'):format(heal, Player.guard)
    end
  end
  Game:pushLog(msg)
end

local function performEnemyTurn(e)
  local atk = love.math.random(1, e.atkDie)
  if e.faction.id=='golem' and love.math.random()<0.25 then e.fortify=true; Game:pushLog('Enemy uses Fortify: +2 defense this turn.') end
  local dmg = atk
  local blocked = math.min(Player.guard, dmg); dmg = dmg - blocked; Player.guard = Player.guard - blocked
  local defDie = playerDefenseDie(); local defRoll = love.math.random(1, defDie) + (Player.defBonus or 0)
  dmg = math.max(0, dmg - defRoll); applyDamage(Player, dmg)
  Game:pushLog(('Enemy attacks: d%d=%d. Your defense: d%d=%d (+%d). Block=%d, damage=%d.'):format(e.atkDie, atk, defDie, defRoll-(Player.defBonus or 0), (Player.defBonus or 0), blocked, dmg))
  if e.faction.id=='demon' and not M.igniteApplied then M.igniteApplied=true; applyDamage(Player, 5); Game:pushLog('Hellfire burns you for 5 damage (once).') end
  if e.boss then
    e.bossCycle = (e.bossCycle or 0) + 1
    if e.faction.id=='undead' then e.hp = utils.clamp(e.hp + 2, 0, e.maxhp); Game:pushLog('Lich drains life: heals 2 HP.')
    elseif e.faction.id=='demon' and e.bossCycle%3==0 then applyDamage(Player, 6); Game:pushLog('Infernal blaze: +6 damage!')
    elseif e.faction.id=='golem' then e.fortify=true; Game:pushLog('Titan steels itself: +2 defense this turn.') end
  end
  if e.fortify then e.fortify=false end
end

function M.start()
  Game.log = {}
  require('game.ui.combatlog').reset()
  Game.state='combat'; Game.canReroll = require('game.core.player').hasArtifact; Game.rerolledThisFight=false
  M.turn='player'; M.awaitingRoll=false; M.action=nil; M.tempRoll=nil; M.enemyActTimer=0.6; M.igniteApplied=false
  M.enemy = EnemyMod.newForFight()
  Game:pushLog(('\n— FIGHT %d —'):format(Game.fightCount+1))
  Game:pushLog(('Enemy: %s (%s)'):format(M.enemy.name, M.enemy.faction.name))
  if M.enemy.boss then Game:pushLog('BOSS! Mechanic: '..(M.enemy.mechanic or '')) end
end

function M.update(dt)
  local e = M.enemy
  require('game.core.dice').update(dt)
  if M.awaitingRoll and not Dice.isRolling and Dice.result then
    M.awaitingRoll=false; M.tempRoll = Dice.result; performPlayerResolved(M.action, M.tempRoll, e)
    if e.hp<=0 then Game.fightCount=Game.fightCount+1; Game.gold=Game.gold + e.gold; Game:pushLog(('Victory! You gain %d gold.'):format(e.gold)); require("game.core.save").saveGame(); Game.state='shop'; Game.screen=require('game.screens.shop'); Game.screen.enter(); return end
    M.turn='enemy'
  end
  if M.turn=='enemy' then M.enemyActTimer = M.enemyActTimer - dt; if M.enemyActTimer<=0 then performEnemyTurn(e); if require('game.core.player').hp<=0 then Game.state='gameover'; Game.screen=require('game.screens.gameover'); Game.screen.enter(); return end; M.turn='player'; M.enemyActTimer=0.6 end end
end

function M.draw()
  local stat = require('game.ui.statpanel')
  local logui = require('game.ui.combatlog')
  local diceui = require('game.ui.diceanim')
  stat.drawPlayer()
  stat.drawEnemy(M.enemy)
  logui.draw()
  diceui.draw()
  love.graphics.printf('Turn: '..M.turn, 360, love.graphics.getHeight()-250, love.graphics.getWidth()-720, 'center')
  love.graphics.printf('[1] Attack  [2] Defend  [3] Skill  [R] Reroll  [Space] roll/confirm', 360, love.graphics.getHeight()-26, love.graphics.getWidth()-720, 'center')
end

function M.keypressed(key)
  local Player = require('game.core.player')
  local Dice = require('game.core.dice')
  local logui = require('game.ui.combatlog')
    if key=='up' or key=='down' or key=='pageup' or key=='pagedown' or key=='home' or key=='end' then
    logui.handleKey(key)
    return
    end
  if key=='r' and Game.canReroll and not Dice.isRolling and M.tempRoll and not Game.rerolledThisFight then Game.rerolledThisFight=true; Game.canReroll=false; Dice.start(Dice.sides); M.awaitingRoll=true; Game:pushLog('Artifact used: reroll!'); return end
  if M.turn~='player' then if key=='space' then M.enemyActTimer=0 end; return end
  if (key=='1' or key=='kp1') and not M.awaitingRoll and not Dice.isRolling then M.action='attack'; Dice.start(Player.attackDieOverride or Player.class.die); M.awaitingRoll=true; Game:pushLog('You ATTACK...')
  elseif (key=='2' or key=='kp2') and not M.awaitingRoll and not Dice.isRolling then M.action='defend'; Dice.start(Player.defDie or 6); M.awaitingRoll=true; Game:pushLog('You DEFEND...')
  elseif (key=='3' or key=='kp3') and not M.awaitingRoll and not Dice.isRolling then M.action='skill'; local sides=(Player.class.id=='barb' and 20) or (Player.class.id=='monk' and 1) or (Player.class.id=='warrior' and 12) or (Player.class.id=='rogue' and (Player.attackDieOverride or Player.class.die)) or 8; Dice.start(sides); M.awaitingRoll=true; Game:pushLog('You use a SKILL...') end
end
return M