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

addPlayer = (game) ->
  startX = 100
  startY = game.world.height - 400
  game.player = game.add.existing new Player(game, startX, startY)

preflight.create = ->
  game = @game
  game.ground = game.add.tileSprite(0, game._HEIGHT - 32, game._WIDTH, 32, "ground")
  game.ground.update = () ->
    rate = @game._SCROLL_RATE
    @tilePosition = x: @tilePosition.x + rate, y: @tilePosition.y
  
  addCountdown @
  addText @
  addBgMusic @
  addCountdown @

startGame = ->
  console.log "startGame"
  state = @
  state._readyText.destroy()
  state._timerText.destroy()
  state._instructionText.destroy()
  state.game.state.start "ingame", false
  
module.exports = preflight
