Player = (game, x, y) ->
  Phaser.Sprite.call @, game, x, y, "naked_dude", 0
  @animations.add "flying", [1,0], 8
  @anchor = new Phaser.Point .5, .5
  @collideWorldBound = true
  @_flapKey = null

Player.prototype = Object.create Phaser.Sprite.prototype
Player.prototype.constructor = Player

module.exports = Player
