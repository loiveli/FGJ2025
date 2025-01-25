extends CharacterBody2D

var targetPosition: Vector2 = position
const speed: int = 25

@export var tweetButton: Button

func _ready():
	tweetButton.tweet_received.connect(_on_tweet_received)
	

func _on_button_send_impulse(impulseVector:Vector2) -> void:
	targetPosition = position + impulseVector


func _process(delta: float) -> void:
	if (position - targetPosition).length()>speed*delta:
		var move = move_and_collide(position.direction_to(targetPosition)*speed*delta)
		if move:
			print(move)
		queue_redraw()
	else:
		position = targetPosition
	
	
func _on_tweet_received(result):
	targetPosition = position + (result*1000)
	
	
func _draw():
	draw_circle((targetPosition-global_position), 10, Color("BLUE"))
