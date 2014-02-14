WIDTH = 800
HEIGHT = 600

game = new Phaser.Game WIDTH, HEIGHT

game._FLAP_VELOCITY = -300
game._GRAVITY = 1200
game._GROUND_HEIGHT = 32
game._WIDTH = WIDTH
game._HEIGHT = HEIGHT
game._KILL_HEIGHT = game._HEIGHT - game._GROUND_HEIGHT - 10
game._START_POSITION = 100
game._SPACE_KEY_CODE = 32
game._SCROLL_RATE = 26
game._UP_KEY_CODE = 38
game._READY_KEY = Phaser.Keyboard.SPACEBAR
game._FLAP_KEY = Phaser.Keyboard.UP
game._MENU_TEXT = "Flappy! \n < SPACE > PUSH IT BRO, PUSH IT!"
game._PREFLIGHT_TEXT = "GET READY TO FLAP FO YO LIVES!"
game._INSTRUCTION_TEXT = "PUSH 'UP ARROW' TO FLAP"
game._TEXT_FONT = "Impact, Charcoal, sans-serif"

preflight = require('./preflight.coffee')
inmenu = require('./inmenu.coffee')
ingame = require('./ingame.coffee')

game.state.add "ingame", ingame, false
game.state.add "preflight", preflight, false
game.state.add "inmenu", inmenu, true
