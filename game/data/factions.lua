return {
  {id='undead', name='Undead', trait='10% chance to resurrect.', color={0.8,1,0.8}, 
    enemies={
      {name='Skeleton', hp=14, atkDie=6, defDie=6, gold=8},
      {name='Ghoul', hp=18, atkDie=8, defDie=6, gold=10},
      {name='Wraith', hp=16, atkDie=10, defDie=8, gold=12}}, 
        boss={name='Lich', hp=45, atkDie=12, defDie=10, gold=40, mechanic='Drain: heals 2 HP every turn.'}},
  {id='demon',  name='Demons', trait='Ignite once: 5 damage to player.', color={1,0.85,0.85}, 
    enemies={
      {name='Imp', hp=16, atkDie=8, defDie=6, gold=10},
      {name='Hellion', hp=22, atkDie=10, defDie=6, gold=12},
      {name='Succubus', hp=20, atkDie=12, defDie=8, gold=14}}, 
        boss={name='Infernal Overlord', hp=55, atkDie=14, defDie=10, gold=50, mechanic='Hellfire: +6 damage every 3 turns.'}},
  {id='golem',  name='Golems', trait='Sometimes Fortify: +2 defense.', color={0.85,0.9,1}, 
    enemies={
      {name='Iron Golem', hp=24, atkDie=8, defDie=10, gold=12},
      {name='Steam Warden', hp=26, atkDie=10, defDie=10, gold=14},
      {name='Mecha Colossus', hp=28, atkDie=12, defDie=12, gold=16}}, 
        boss={name='Mechanical Titan', hp=60, atkDie=16, defDie=12, gold=55, mechanic='Permanent Fortify: +2 defense.'}},
}