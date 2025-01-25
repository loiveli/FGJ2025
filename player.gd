extends CharacterBody2D

var targetPosition: Vector2 = position
const speed: int = 25
var bubbles: Dictionary

@export var tweetButton: Button

func _ready():
	tweetButton.tweet_received.connect(_on_tweet_received)
	var childNodes = $"..".get_children().filter(func (child): return child is StaticBody2D)
	for node in childNodes:
		bubbles[node.bubble] = node
	
	

func _on_button_send_impulse(impulseVector:Vector2) -> void:
	targetPosition = position + impulseVector


func _physics_process(delta: float) -> void:
	if (position - targetPosition).length()>speed*delta:
		var move = move_and_collide(position.direction_to(targetPosition)*speed*delta)
		if move:
			position = Vector2(250,250)
			print(move)
		queue_redraw()
	else:
		position = targetPosition
	
	
func _on_tweet_received(result):
	
	var moveVector = Vector2(0,0)
	for similarity in result:
		print(str(similarity.bubble)+ " : " + str(similarity.value))
		var maxValue = 0
		if similarity.value > 0.3 and similarity.value > maxValue/2.0:
			maxValue = similarity.value if similarity.value >  maxValue else maxValue
			var bubble = bubbles[similarity.bubble]
			moveVector += position.direction_to(bubble.position) * (similarity.value*500)
	targetPosition = position+ moveVector

	
	
func _draw():
	draw_circle((targetPosition-global_position), 10, Color("BLUE"))
