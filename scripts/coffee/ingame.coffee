ingame = new Phaser.State
Player = require "./player.coffee"

ingame.create = ->
  @game._timer = @game.time.events.loop(3000, ingame.createPipe, @)
  @game._pipes = @game.add.group()
  @game._safeZones = @game.add.group()
  i = 0
  
  
ingame.update = ->
  ground = @game._ground
  pipes = @game._pipes
  safeZone = @game._safeZones
  i = 0
  j=0
  players = @game._playerGroup
  while i < players.length  
    @game.physics.overlap(players.getAt(i),pipes,handleCollision, null, @)
    i++
  #TODO: if player is below kill height then kill them
  #loop over players and check if they are below kill height
  #if they are, call player.hitGround()
  #if all players are dead, call cleanup
  while j < players.length
    if players.getAt(j).y > @game._KILL_HEIGHT && !players.getAt(j)._dying
      players.getAt(j).hitGround()
    j++
  
  if !players
    ingame.cleanup()
  
  if players.countDead() == players.length 
    ingame.cleanup()
  
  
ingame.createPipe = ->
  #determine the safe zone of each pipe column  (max - min + 1) + min
  safeZoneLocation = Math.floor(Math.random() * (400 - 150 + 1)) + 150
  pipes = @game._pipes
  safeZones = @game._safeZones
  
  
  #top and bottom of pipe Group
  pipeTop = @game.add.sprite(750, (safeZoneLocation - 100 - 525 ), "pipe_top")
  pipeBottom = @game.add.sprite(750, safeZoneLocation + 125, "pipe_bottom")
  safeZone = @game.add.sprite(750, safeZoneLocation, "safe_zone")
  
  safeZone.body.velocity.x = -600
  pipeTop.body.velocity.x = -600
  pipeBottom.body.velocity.x = -600
  
  pipes.add(pipeTop)
  pipes.add(pipeBottom)
  safeZones.add(safeZone)
 
handleCollision = (player, pipe)->
  players = @game._playerGroup
  livingPlayers = players.countLiving()
  unless player._dying then player.collide(pipe.body.velocity.x)
  console.log players.countDead()
  
  
ingame.cleanup = () ->
  @game._playerGroup.destroy()
  @game._safeZones.removeAll()
  @game._safeZoneCounter = 0
  @game.time.events.remove(@game._timer)
  @game._pipes.removeAll()
  @game.state.start "preflight", false


module.exports = ingame
