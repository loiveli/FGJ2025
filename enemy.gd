extends CharacterBody2D

var targetPosition: Vector2
const SPEED = 20
@export var player: CharacterBody2D

func _ready():
	targetPosition = player.position

func _physics_process(delta: float) -> void:
	
	if (position-targetPosition).length() < SPEED*delta:
		targetPosition = player.position
	else:
		move_and_collide(position.direction_to(targetPosition) * SPEED *delta)
		queue_redraw()

func _draw():
	draw_circle((targetPosition-global_position), 10, Color("RED"))