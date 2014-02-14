ingame = new Phaser.State

ingame.create = ->
  @game._timer = @game.time.events.loop(3000, ingame.createPipe, @)
  
  @game._pipes = @game.add.group()
  @game._safeZones = @game.add.group()
  
  flapKey = @game.input.keyboard.addKey @game._FLAP_KEY
  flapKey.onDown.add toggleFlap, @

  @_flapSound = @game.add.audio "flap"
  @_deathSound = @game.add.audio "death"
  @_pointSound = @game.add.audio "point"
  @_flapKey = flapKey
  @_shouldFlap = false

ingame.update = ->
  game = @game
  ground = game._ground
  player = @game._player
  ground = @game._ground
  pipes = @game._pipes
  safeZone = @game._safeZones
  
  #@game.physics.collide(player, ground, handleCollision, null, @)
  #@game.physics.overlap(player, ground, handleCollision, null, @)
  #
  #@game.physics.overlap(player,pipes,handleCollision, null, @)
  #
  
  #if @_playerAlive
  #  if @_shouldFlap
  #    @_flapSound.play()
  #    player.animations.play "flying"
  #    player.body.velocity.y = @game._FLAP_VELOCITY
  #    @_shouldFlap = false

  
ingame.createPipe = ->
  player = @game._player
  #determine the safe zone of each pipe column  (max - min + 1) + min
  safeZoneLocation = Math.floor(Math.random() * (400 - 150 + 1)) + 150
  pipes = @game._pipes
  safeZones = @game._safeZones
  if @_playerAlive
    pipeTop = @game.add.sprite(700, (safeZoneLocation - 100 - 525 ), "pipe_top")
    pipeBottom = @game.add.sprite(700, safeZoneLocation + 125, "pipe_bottom")
   
    safeZone = @game.add.sprite(700, safeZoneLocation, "safe_zone")
    
    safeZone.body.velocity.x = -250
    pipeTop.body.velocity.x = -250
    pipeBottom.body.velocity.x = -250
    
    pipes.add(pipeTop)
    pipes.add(pipeBottom)
    safeZones.add(safeZone)
 
handleCollision = ->
    @_deathSound.play()
  
  #@game._player.body.angularVelocity = 1500
 
  @game._pipes.forEach((obj)->
    obj.body.velocity.x = 0
  )
  @game._safeZones.removeAll()
  
  if @game._player.y > @game._KILL_HEIGHT
    @game._safeZoneCounter = 0
    @game._safeZoneIDs = []
    @game._player.kill()
    @game.time.events.remove(@game._timer)
    @game._pipes.removeAll()
    @game.state.start "preflight", false

updateGround = (ground, rate) ->
  ground.tilePosition = x: ground.tilePosition.x + rate, y: ground.tilePosition.y
    
toggleFlap = ->
  @_shouldFlap = true
  
module.exports = ingame
