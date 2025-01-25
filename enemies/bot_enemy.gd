extends CharacterBody2D

var targetPosition: Vector2
const SPEED = 100

func _ready():
	# Target is in the direction of the player but further away.
	# Reaching the target destroys the bot.
	var player = get_node("/root/Node2D/Player")	# Disgusting.
	targetPosition = self.to_local(player.position) * 10

func _physics_process(delta: float) -> void:
	
	if (position-targetPosition).length() < SPEED*delta:
		# Bot hit its target without hitting the player, so it dies.
		queue_free()
	else:
		queue_redraw()
		
	var collision = move_and_collide(position.direction_to(targetPosition) * SPEED *delta)
	if collision:
		collision.get_collider().followers += 20
		queue_free()
