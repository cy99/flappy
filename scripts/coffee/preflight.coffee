preflight = new Phaser.State

preflight.create = ->
  @_bgm = @game.add.audio "bgm"
  @_bgm.play()
  player = @game.add.sprite(100, @game.world.height - 400, "naked_dude")
  player.body.collideWorldBounds = true
  player.animations.add("flying", [1,0], 8)
  player.frame = 0
  player.anchor = new Phaser.Point .5, .5
  @_secondsTillGameStarts = "" 
  @_timeStamp = 0
  ground = @game.add.tileSprite(0, @game._HEIGHT - 32, @game._WIDTH, 32, "ground")
  
  readyKey = @game.input.keyboard.addKey @game._FLAP_KEY
   
  @game._safeZoneCounter = 0
  @game._safeZoneIDs = []
  @game._score = 0
  @_readyText = @game.add.text(100, 100, @game._PREFLIGHT_TEXT, font: '32px comic sans ms', fill: '#000')
  @_instructionText = @game.add.text(150, 190, @game._INSTRUCTION_TEXT, font: '24px comic sans ms', fill: '#000')
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
  updateGround ground, @game._SCROLL_RATE  
  @_readyKey.onDown.add countDownToStart, @
 
updateGround = (ground, rate) ->
  ground.tilePosition = x: ground.tilePosition.x + rate, y: ground.tilePosition.y
 
module.exports = preflight
  
  

