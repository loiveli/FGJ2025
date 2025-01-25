extends CharacterBody2D

var targetPosition: Vector2
const SPEED = 200
@export var player: CharacterBody2D

func _ready():
	targetPosition = player.position

func _physics_process(delta: float) -> void:
	
	if (position-targetPosition).length() < SPEED*delta:
		targetPosition = player.position
	else:
		queue_redraw()
	var collision = move_and_collide(position.direction_to(targetPosition) * SPEED *delta)
	if collision:
		print(collision.get_collider())
		collision.get_collider().followers -= 2
		queue_free()

func _draw():
	draw_circle((targetPosition-global_position), 10, Color("RED"))
