inmenu = new Phaser.State

toggleReady = -> @_ready = true

inmenu.preload = -> 
  @game.input.keyboard.addKeyCapture [@game._SPACE_KEY_CODE, @game._UP_KEY_CODE]
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

  readyKey = @game.input.keyboard.addKey @game._READY_KEY
  readyKey.onDown.add toggleReady, @

  @_readyKey = readyKey
  @_ready = false
  @_menuText = @game.add.text(100, 100, @game._MENU_TEXT, font: '32px impact', fill: '#000', align: 'center')

inmenu.update = ->
  if @_ready
    @game.state.start "preflight", false
    @_menuText.destroy()

module.exports = inmenu    