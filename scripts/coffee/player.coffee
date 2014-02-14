Player = (game, x, y) ->
  Phaser.Sprite.call @, game, x, y, "naked_dude", 0
  @animations.add "flying", [1,0], 8
  @anchor = new Phaser.Point .5, .5
  @collideWorldBound = true
  @_dying = false
  @_flapVelocity = -300
  @_flapKey = null
  @_flapSound = game.add.audio "flap"
  @_deathSound = game.add.audio "death"

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

Player.prototype.hitGround = () ->
  @_deathSound.play()
  @kill()

module.exports = Player
