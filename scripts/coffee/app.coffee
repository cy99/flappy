FLAP_VELOCITY = -300
GRAVITY = 25
WIDTH = 800
HEIGHT = 600
START_POSITION = 100
SPACE_KEY_CODE = 32
UP_KEY_CODE = 38
READY_KEY = Phaser.Keyboard.SPACEBAR
FLAP_KEY = Phaser.Keyboard.UP

#height of the hole you can fly through
DIFFICULTY_SETTINGS = 100

handleCollision = -> @game.state.start "inmenu"

toggleFlap = -> @_shouldFlap = true

toggleReady = -> @_ready = true

game = new Phaser.Game WIDTH, HEIGHT

preflight = new Phaser.State

preflight.create = ->
  player = @game.add.sprite(100, @game.world.height - 150, "dude")
  player.body.collideWorldBounds = true
  player.animations.add "flying", [5,6,7,8], 4, true
  player.animations.play "flying"
  player.anchor = new Phaser.Point .5, .5

  phantomPlayer = @game.add.sprite(300, @game.world.height - 200, "dude")
  phantomPlayer.animations.add "flying", [5,6,7,8], 4, true
  phantomPlayer.animations.play "flying"

  ground = @game.add.tileSprite(0, HEIGHT - 32, 32 * 25, 32, "ground")
  ground.body.immovable = true

  readyKey = @game.input.keyboard.addKey FLAP_KEY
  readyKey.onDown.add toggleFlap, @
 
  @game._score = 0
  @game._scoreText = @game.add.text(16, 16, "#{@game._score}", font: '32px arial', fill: '#000')
  @game._player = player
  @game._ground = ground
  @_readyKey = readyKey
  @_shouldFlap = false
  @_phantomPlayer = phantomPlayer

preflight.update = ->
  if @_shouldFlap
    @_phantomPlayer.destroy()
    @game.state.start "ingame", false

ingame = new Phaser.State

ingame.create = ->
  @game._player.body.gravity.y = GRAVITY
  @game._player.body.collideWorldBounds = true
  @game.time.events.loop(3000, ingame.createPipe, @)
  #group of all pipe columns
  pipeColumnGroup = @game.add.group()  
  @game._pipeColumnGroup = pipeColumnGroup
  
  flapKey = @game.input.keyboard.addKey FLAP_KEY
  flapKey.onDown.add toggleFlap, @

  @_flapKey = flapKey
  @_shouldFlap = false

ingame.update = ->
  player = @game._player
  ground = @game._ground
  @game.physics.collide(player, ground, handleCollision, null, @)
  @game.physics.overlap(player, ground, handleCollision, null, @)

  player.body.rotation = if player.body.velocity.y < 0 then -40 else 60
  if @_shouldFlap
    player.body.velocity.y = FLAP_VELOCITY
    @_shouldFlap = false
  
    
  @game._scoreText.content = "#{@game._score}"

  
ingame.createPipe = ->  
  #determine the safe zone of each pipe column
  safeZoneLocation = Math.floor(Math.random() * (400 - 150 + 1)) + 150
  
  #each individual pipe column 
  pipeGroup = @game.add.group()

  #top and bottom of pipe Group
  pipeTop = pipeGroup.create(700, (safeZoneLocation - 100 - 500 ), "pipe_top")
  pipeBottom = pipeGroup.create(700, safeZoneLocation + 100, "pipe_bottom")  
  safeZone = pipeGroup.create(700, safeZoneLocation, "safe_zone")
  
  safeZone.body.velocity.x = -200
  pipeTop.body.velocity.x = -200
  pipeBottom.body.velocity.x = -200
  
  @game._pipeColumnGroup.add(pipeGroup)
  
  
  
inmenu = new Phaser.State

inmenu.preload = ->
  @game.input.keyboard.addKeyCapture [SPACE_KEY_CODE, UP_KEY_CODE]
  @game.load.image('sky', '/assets/images/sky.png')
  @game.load.image('ground', '/assets/images/grass_32x32.png')
  @game.load.spritesheet('dude', '/assets/images/dude.png', 32, 48)
  @game.load.image('pipe_top', '/assets/images/pipe_top.png')
  @game.load.image('pipe_bottom', '/assets/images/pipe_bottom.png')
  @game.load.image('safe_zone', '/assets/images/safe_zone.png')
inmenu.create = ->
  @game.add.sprite(0, 0, 'sky')

  readyKey = @game.input.keyboard.addKey READY_KEY
  readyKey.onDown.add toggleReady, @

  @_readyKey = readyKey
  @_ready = false
  @_menuText = @game.add.text(100, 100, 'Hit space to play!', font: '32px arial', fill: '#000')

inmenu.update = ->
  if @_ready
    @game.state.start "preflight", false
    @_menuText.destroy()

game.state.add "ingame", ingame, false
game.state.add "preflight", preflight, false
game.state.add "inmenu", inmenu, true
