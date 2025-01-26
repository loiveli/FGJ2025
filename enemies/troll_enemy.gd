extends CharacterBody2D

var collisionType = "BOT"

var targetPosition: Vector2
var last_position: Vector2
const SPEED = 50

func _ready():
	var player = get_node("/root/Node2D/Player")
	targetPosition = self.to_global(player.position)

func _physics_process(delta: float) -> void:
	var player = get_node("/root/Node2D/Player")
	
	targetPosition = self.to_local(player.position) + self.position
	
	var collision = move_and_collide(position.direction_to(targetPosition) * SPEED * delta)
	
	if collision and collision.get_collider().collisionType == "PLAYER":
		collision.get_collider().followers += collision.get_collider().followers*0.25
		queue_free()
