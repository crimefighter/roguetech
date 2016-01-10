require 'rubygems'
require 'gosu'
require 'aasm'
require 'polaris'
require 'two_d_grid_map'
require 'bresenham'

require './lib/carl-ellis-dungeon/Branch.rb'
require './lib/carl-ellis-dungeon/Direction.rb'
require './lib/carl-ellis-dungeon/RoomBranch.rb'
require './lib/carl-ellis-dungeon/CorridorBranch.rb'
require './lib/carl-ellis-dungeon/Cell.rb'
require './lib/carl-ellis-dungeon/Dungeon.rb'
require './lib/carl-ellis-dungeon/CircularDungeon.rb'

require './entities/battlefield/behaviors/playable.rb'
require './entities/battlefield/behaviors/passive.rb'
require './entities/battlefield/behaviors/damageable.rb'
require './entities/battlefield/behaviors/killable.rb'
require './entities/battlefield/behaviors/sighted.rb'
require './entities/battlefield/behaviors/visible.rb'

require './entities/battlefield/actions/base.rb'
require './entities/battlefield/actions/move.rb'
require './entities/battlefield/actions/attack.rb'
require './entities/battlefield/actions/take_damage.rb'
require './entities/battlefield/actions/die.rb'

require './entities/battlefield/battlefield.rb'
require './entities/battlefield/tile.rb'
require './entities/battlefield/actor.rb'
require './entities/battlefield/turn.rb'

require './services/viewport.rb'
require './services/user_input.rb'
require './services/user_input_handler.rb'

require './services/concerns/drawable.rb'

require './services/renderers/battlefield.rb'
require './services/renderers/battlefield_tile.rb'
require './services/renderers/battlefield_actor.rb'

require './services/media_loader.rb'
require './services/game_window.rb'
require './services/logger.rb'
require './services/battlefield_grid_map.rb'
require './services/battlefield_grid_location.rb'

window = GameWindow.new
window.show
