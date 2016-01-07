require 'rubygems'
require 'gosu'
require 'aasm'

require './entities/battlefield/behaviors/playable.rb'
require './entities/battlefield/behaviors/idle.rb'
require './entities/battlefield/behaviors/damageable.rb'
require './entities/battlefield/behaviors/killable.rb'

require './entities/battlefield/actions/base.rb'
require './entities/battlefield/actions/move.rb'
require './entities/battlefield/actions/attack.rb'
require './entities/battlefield/actions/die.rb'

require './entities/battlefield/battlefield.rb'
require './entities/battlefield/tile.rb'
require './entities/battlefield/actor.rb'
require './entities/battlefield/turn.rb'

require './services/viewport.rb'
require './services/keyboard.rb'
require './services/keyboard_handler.rb'

require './services/concerns/drawable.rb'

require './services/renderers/battlefield.rb'
require './services/renderers/battlefield_tile.rb'
require './services/renderers/battlefield_actor.rb'

require './services/media_loader.rb'
require './services/game_window.rb'
require './services/logger.rb'

window = GameWindow.new
window.show
