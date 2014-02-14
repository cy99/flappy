Player = require "./player.coffee"

preflight = new Phaser.State

addText = (state) ->
  preflightText = "Get ready to flap!"
  instructionText = "Push a key to enter this bitch"
  state._readyText = state.game.add.text(100, 100, preflightText, font: '32px comic sans ms', fill: '#000')
  state._instructionText = state.game.add.text(150, 190, instructionText, font: '24px comic sans ms', fill: '#000')
  state._timerText = state.game.add.text(350, 200, "", font: '150px comic sans ms', fill: 'red')
  state._timerText.update = ->
    @content = Math.round((Date.now() - state._startTime) / 1000)

addBgMusic = (state) ->
  state.add.audio "bgm", true

addCountdown = (state, events) ->
  state._startTime = Date.now()
  setTimeout(startGame.bind(state), 3000)

addPlayer = (key) ->
  game = @game
  keyCode = key.keyCode || key.which
  keyIsAvailable = !@_keyMap[keyCode]
  if game.state.current == "preflight" && keyIsAvailable
    @_keyMap[keyCode] = true
    startX = 100
    startY = game.world.height - 400
    game._playerGroup.add new Player(game, startX, startY, keyCode)
    
    
    
resetKeyMap = (state) ->
  state._keyMap = {}

preflight.create = ->
  game = @game
  game.ground = game.add.tileSprite(0, game._HEIGHT - 32, game._WIDTH, 32, "ground")
  game.ground.update = () ->
    rate = @game._SCROLL_RATE
    @tilePosition = x: @tilePosition.x + rate, y: @tilePosition.y
  
  game._playerGroup = game.add.group()
  resetKeyMap @
  addCountdown @
  addText @
  addBgMusic @
  addCountdown @

  #TODO: temporary sheit for testing
  game.input.keyboard.addCallbacks @, addPlayer

preflight.update = ->
  players = @game._playerGroup
  i = 0 
  while i < players.length
    if players.getAt(i).y > @game._KILL_HEIGHT && !players.getAt(i)._dying
      players.getAt(i).hitGround()
    i++
     
     
startGame = ->
  state = @
  state._readyText.destroy()
  state._timerText.destroy()
  state._instructionText.destroy()
  state.game.state.start "ingame", false
  
module.exports = preflight
