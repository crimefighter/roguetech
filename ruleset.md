# Actions

Actions are performed by actors during their turn. Each actor can perform unlimited number of actions if they have enough AP. Base attributes of every action are AP cost and range. If action requires a target, target tile must be within range of action. Range of zero means action can be only performed on self.
AP cost and Range can be modified by weapons and other equipment.

## Attack
Range: 1
AP cost: 1
Properties: Damage
Try to deal damage to target actor. If attack succeeds, target actor performs TakeDamage action.
Base attack's damage is equal to actor's STR and is further modified by weapons and other equipment.

## TakeDamage
Range: 0
AP cost: 0
Properties: Damage
This action is invoked when actor is a target of successful attack. The fate of actor is then determined.
Possible outcomes:
* If damage is less than CON, attack is ignored.
* If damage is more than CON, 

##
