require 'gosu'

require './entities/battlefield/battlefield.rb'
require './entities/battlefield/tile.rb'
require './entities/battlefield/actor.rb'
require './entities/battlefield/playable.rb'

require './services/viewport.rb'
require './services/keyboard.rb'
require './services/keyboard_handler.rb'

require './services/concerns/drawable.rb'

require './services/renderers/battlefield.rb'
require './services/renderers/battlefield_tile.rb'
require './services/renderers/battlefield_actor.rb'

require './services/media_loader.rb'
require './services/game_window.rb'

window = GameWindow.new
window.show
