WIDTH = 800
HEIGHT = 600

game = new Phaser.Game WIDTH, HEIGHT

game._GRAVITY = 1200
game._GROUND_HEIGHT = 32
game._WIDTH = WIDTH
game._HEIGHT = HEIGHT
game._KILL_HEIGHT = game._HEIGHT - game._GROUND_HEIGHT - 10
game._SCROLL_RATE = 26

preflight = require('./preflight.coffee')
inmenu = require('./inmenu.coffee')
ingame = require('./ingame.coffee')

game.state.add "ingame", ingame, false
game.state.add "preflight", preflight, false
game.state.add "inmenu", inmenu, true
