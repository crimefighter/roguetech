# Reproduce

Reproduce is a game of survival in a primordial world. You start as a lone primitive being and must immediately care about things like finding food and shelter to survive. If you manage to live long enough, you can greatly improve your chances of survival by:

* Collecting resources such as wood and bones and creating tools and weapons that will aid your survival.
* Mastering skills that will let you become the fastest, sneakiest or simply the most fearsome animal around.
* Finding others of your kind and convincing them to join your tribe. You will find that hunting is much easier in a group.
* Doing science and art to sharpen your intellect and gain knowledge of the world.
* Producing children that will carry on living should you suddenly die.

## Game

Reproduce is a turn based roguelike game taking place on a two dimensional grid.

## Vocabulary

### Tile

One tile on a two dimensional game map represents a location in the world that one Actor can occupy. There are various types of tiles that affect movement and other actions performed on this tile.

### Actor

A game entity that can perform Actions. Actor occupies one tile on the game map.

### Action

Action is anything that changes the state of any Actor, and Actor's state can only be changed through Action.
* Action is performed by Actor and has a target tile. Some actions require target tile to be occupied by a suitable actor, for example enemy or performing Actor itself.
* Action can be only performed during performing Actor's turn.
* Action has AP cost and can only be performed when performing Actor has enough AP. AP cost is subtracted from player's AP when Action is performed. AP cost is influenced by various factors such as actor's Stats or Effects. AP cost can be 0.

## Actions

### Walk
### Attack Actor
### Give Way
### Take Damage
### Die
### Pick Up Item
### Drop Item
### Equip item
### Eat
### Create Item
### Create Structure
### Interact With Actor
### Command Actor
