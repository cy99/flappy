Player = (game, x, y, flapKey) ->
  Phaser.Sprite.call @, game, x, y, "naked_dude", 0
  @animations.add "flying", [1,0], 8
  @anchor = new Phaser.Point .5, .5
  @collideWorldBound = true
  @_dying = false
  @_flapVelocity = -300
  @body.gravity.y = 1200
  @_flapKey = game.input.keyboard.addKey flapKey
  @_flapKey.onDown.add @flap, @
  @_flapSound = game.add.audio "flap"
  @_deathSound = game.add.audio "death"
  @

Player.prototype = Object.create Phaser.Sprite.prototype
Player.prototype.constructor = Player
Player.prototype.flap = () ->
  @_flapSound.play()
  @animations.play "flying"
  @body.velocity.y = @_flapVelocity

Player.prototype.collide = (vel) ->
  @_deathSound.play()
  @_dying = true
  @body.velocity.x = vel
  @body.angularVelocity = 1500
  @kill()
  
Player.prototype.hitGround = () ->
  console.log 'hitground'
  @_deathSound.play()
  @_dying = true
  @_flapKey.onDown.removeAll()
  @kill()

module.exports = Player
