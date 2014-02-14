ingame = new Phaser.State

ingame.create = ->
  @game._timer = @game.time.events.loop(3000, ingame.createPipe, @)
  @game._pipes = @game.add.group()
  @game._safeZones = @game.add.group()
  
ingame.update = ->
  ground = @game._ground
  pipes = @game._pipes
  safeZone = @game._safeZones
  
  @game.physics.overlap(player,pipes,handleCollision, null, @)
  #TODO: if player is below kill height then kill them
  #loop over players and check if they are below kill height
  #if they are, call player.hitGround()
  #if all players are dead, call cleanup
  
  
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
  unless player._dying then player.collide(pipe.body.velocity.x)

ingame.cleanup = () ->
  @game._safeZones.removeAll()
  @game._safeZoneCounter = 0
  @game.time.events.remove(@game._timer)
  @game._pipes.removeAll()
  @game.state.start "preflight", false


module.exports = ingame
