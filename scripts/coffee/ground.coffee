updateGround = (ground, rate) ->
  ground.tilePosition = x: ground.tilePosition.x + rate, y: ground.tilePosition.y

module.exports = {updateGround}
