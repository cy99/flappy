FLAP_VELOCITY = -300
GRAVITY = 1200
GROUND_HEIGHT = 32
WIDTH = 800
HEIGHT = 600
KILL_HEIGHT = HEIGHT - GROUND_HEIGHT - 10
START_POSITION = 100
SPACE_KEY_CODE = 32
SCROLL_RATE = 30
UP_KEY_CODE = 38
READY_KEY = Phaser.Keyboard.SPACEBAR
FLAP_KEY = Phaser.Keyboard.UP
MENU_TEXT = "Flappy! \n < SPACE > PUSH IT BRO, PUSH IT!"
PREFLIGHT_TEXT = "GET READY TO FLAP FO YO LIVES!"
INSTRUCTION_TEXT = "PUSH 'UP ARROW' TO FLAP"
TEXT_FONT = "Impact, Charcoal, sans-serif"

handleCollision = ->
  if @_playerAlive
    @_deathSound.play()
  @_playerAlive = false
  
  @game._player.body.angularVelocity = 1500
 
  @game._pipes.forEach((obj)->
    obj.body.velocity.x = 0
  )
  @game._safeZones.removeAll()  
  
  if @game._player.y > KILL_HEIGHT
    @game._safeZoneCounter = 0
    @game._safeZoneIDs = []
    @game._player.kill()
    @game._score = 0
    @game._scoreText.destroy()
    @game.time.events.remove(@game._timer)
    @game._pipes.removeAll()
    @game.state.start "preflight", false
    
  
toggleFlap = -> 
  @_shouldFlap = true

toggleReady = -> @_ready = true

updateGround = (ground, rate) ->
  ground.tilePosition = x: ground.tilePosition.x + rate, y: ground.tilePosition.y

game = new Phaser.Game WIDTH, HEIGHT

preflight = new Phaser.State

preflight.create = ->
  @_bgm = game.add.audio "bgm"
  @_bgm.play()
  player = @game.add.sprite(100, @game.world.height - 400, "naked_dude")
  player.body.collideWorldBounds = true
  player.animations.add("flying", [1,0], 8)
  player.frame = 0
  player.anchor = new Phaser.Point .5, .5
  @_secondsTillGameStarts = "" 
  @_timeStamp = 0
  ground = game.add.tileSprite(0, HEIGHT - 32, WIDTH, 32, "ground")
  
  readyKey = @game.input.keyboard.addKey FLAP_KEY
   
  @game._safeZoneCounter = 0
  @game._safeZoneIDs = []
  @game._score = 0
  @_readyText = @game.add.text(100, 100, PREFLIGHT_TEXT, font: '32px comic sans ms', fill: '#000')
  @_instructionText = @game.add.text(150, 190, INSTRUCTION_TEXT, font: '24px comic sans ms', fill: '#000')
  @game._scoreText = @game.add.text(16, 16, "#{@game._score}", font: '32px impact', fill: '#000')
  @game._timerText = @game.add.text(350, 200, "#{@_secondsTillGameStarts}", font: '150px comic sans ms', fill: 'red')         
  @game._player = player
  @game._ground = ground
  @_readyKey = readyKey
  @_shouldFlap = false
  @_playerAlive = false

  
startGame = ->
  
  @_shouldFlap = true  
  @game.state.start "ingame", false
  
    

  
countDownToStart = ->
  @_secondsTillGameStarts = 3
  if @_readyText && @_instructionText
    @_readyText.destroy()
    @_instructionText.destroy()
  countdown = @game._countdownTimer = @game.time.events.add(3200, startGame, @)
  @_timeStamp = countdown.timer.seconds
  
preflight.update = ->
  timer = @game._countdownTimer
  if timer
    @_secondsTillGameStarts = Math.floor(4 - (timer.timer.seconds - @_timeStamp))
    
  if @_secondsTillGameStarts > 0 && @_secondsTillGameStarts < 4
    @game._timerText.content = "#{@_secondsTillGameStarts}"
  else if @_secondsTillGameStarts == 0
    @game._timerText.content = "GO"
  else 
    @game._timerText.content = ""
    
  @game._player.body.rotation = 0
  ground = @game._ground
  updateGround ground, SCROLL_RATE  
  @_readyKey.onDown.add countDownToStart, @
    

  
ingame = new Phaser.State

ingame.create = ->
  @game._timerText.content = ""
  @game._player.body.gravity.y = GRAVITY
  @game._player.body.collideWorldBounds = true 
  @game._timer = @game.time.events.loop(3000, ingame.createPipe, @)
  
  @game._pipes = @game.add.group()
  @game._safeZones = @game.add.group()
  
  flapKey = @game.input.keyboard.addKey FLAP_KEY
  flapKey.onDown.add toggleFlap, @

  @_flapSound = game.add.audio "flap"
  @_deathSound = game.add.audio "death"
  @_pointSound = game.add.audio "point"
  @_flapKey = flapKey
  @_shouldFlap = false
  @_playerAlive = true

ingame.update = ->
  game = @game
  player = game._player
  ground = game._ground
  if player.y > KILL_HEIGHT then handleCollision.call @
  
  if @_playerAlive
    updateGround ground, SCROLL_RATE

  if player.body.velocity.y > 0
    if player.body.rotation < 80
      player.body.rotation += 5
  else
    player.body.rotation = 0

  player = @game._player
  ground = @game._ground
  pipes = @game._pipes
  safeZone = @game._safeZones
  
  @game.physics.collide(player, ground, handleCollision, null, @)
  @game.physics.overlap(player, ground, handleCollision, null, @)
  
  @game.physics.overlap(player,pipes,handleCollision, null, @)
  
  @game.physics.overlap(player,safeZone,addPoint, null, @)
  
  if @_playerAlive
    if @_shouldFlap
      @_flapSound.play()
      player.animations.play "flying"
      player.body.velocity.y = FLAP_VELOCITY
      @_shouldFlap = false
  @game._scoreText.content = "#{@game._score}"

  
ingame.createPipe = ->
  player = @game._player
  #determine the safe zone of each pipe column  (max - min + 1) + min
  safeZoneLocation = Math.floor(Math.random() * (400 - 150 + 1)) + 150
  pipes = @game._pipes
  safeZones = @game._safeZones
  if @_playerAlive
    #top and bottom of pipe Group
    pipeTop = @game.add.sprite(700, (safeZoneLocation - 100 - 525 ), "pipe_top")
    pipeBottom = @game.add.sprite(700, safeZoneLocation + 125, "pipe_bottom")
   
    safeZone = @game.add.sprite(700, safeZoneLocation, "safe_zone")
    
    # newId = @game._safeZoneCounter + 1
    # @game._safeZoneCounter = newId
    # @game._safeZoneIDs.push(newId)
    
    safeZone.body.velocity.x = -250
    pipeTop.body.velocity.x = -250
    pipeBottom.body.velocity.x = -250
    
    pipes.add(pipeTop)
    pipes.add(pipeBottom)
    safeZones.add(safeZone)
 
addPoint = (player, zone)->
  @_pointSound.play()
  @game._score += 1
  zone.destroy()
  
inmenu = new Phaser.State

inmenu.preload = -> 
  @game.input.keyboard.addKeyCapture [SPACE_KEY_CODE, UP_KEY_CODE]
  @game.load.image('sky', '/assets/images/sky.png')
  @game.load.image('ground', '/assets/images/grass_32x32.png')
  @game.load.spritesheet('naked_dude', '/assets/images/big_dude.png', 72, 72)
  @game.load.audio('flap', '/resources/sounds/Flap.ogg')
  @game.load.audio("death", '/resources/sounds/Death.ogg')
  @game.load.audio("point", "/resources/sounds/Point.ogg")
  @game.load.audio("bgm", "/resources/sounds/music.ogg")

  @game.load.image('pipe_top', '/assets/images/pipe_top.png', 100, 600)
  @game.load.image('pipe_bottom', '/assets/images/pipe_bottom.png', 100, 600)
  @game.load.image('safe_zone', '/assets/images/safe_zone.png', 100, 100)

inmenu.create = ->
  @game.add.sprite(0, 0, 'sky')

  readyKey = @game.input.keyboard.addKey READY_KEY
  readyKey.onDown.add toggleReady, @

  @_readyKey = readyKey
  @_ready = false
  @_menuText = @game.add.text(100, 100, MENU_TEXT, font: '32px impact', fill: '#000', align: 'center')

inmenu.update = ->
  if @_ready
    @game.state.start "preflight", false
    @_menuText.destroy()

game.state.add "ingame", ingame, false
game.state.add "preflight", preflight, false
game.state.add "inmenu", inmenu, true
