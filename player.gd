extends CharacterBody2D

var targetPosition: Vector2 = position
const speed: int = 25
@export var followerLabel: Label
var bubbles: Dictionary
var followers: int:
	set(value):
		followers = value
		followerLabel.text = "Followers: " + str(followers)
	

@onready
var animation_player: AnimationPlayer = $Animated/AnimationPlayer
var is_moving: bool = false


@export var tweetButton: Button

func _ready():
	followers = 10
	tweetButton.tweet_received.connect(_on_tweet_received)
	var childNodes = $"..".get_children().filter(func(child): return child is StaticBody2D)
	for node in childNodes:
		bubbles[node.bubble] = node
	
	
func _on_button_send_impulse(impulseVector: Vector2) -> void:
	targetPosition = position + impulseVector


func _physics_process(delta: float) -> void:
	var move = Vector2(0, 0)
	
	if (position - targetPosition).length() > speed * delta:
		move = position.direction_to(targetPosition) * speed * delta
	else:
		position = targetPosition
		self.animation_player.stop(false)
	var collision = move_and_collide(move)
	if collision:
		followers -=2
		
	
	
	
	

func _on_tweet_received(text, result):
	
	var moveVector = Vector2(0, 0)
	for similarity in result:
		print(str(similarity.bubble) + " : " + str(similarity.value))
		var maxValue = 0
		if similarity.value > 0.3 and similarity.value > maxValue / 2.0:
			maxValue = similarity.value if similarity.value > maxValue else maxValue
			var bubble = bubbles[similarity.bubble]
			moveVector += position.direction_to(bubble.position) * (similarity.value * 500)
	targetPosition = position + moveVector
	
	if targetPosition != self.position:
		self.animation_player.scale.x = -1 if targetPosition.x < self.position.x else 1
		self.animation_player.play("walk")
	
func _draw():
	draw_circle((targetPosition - global_position), 10, Color("BLUE"))
