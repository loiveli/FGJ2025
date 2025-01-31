extends CharacterBody2D



var targetPosition: Vector2 = position
var collisionType = "PLAYER"
var speed: int = 25
@export var tweetTarget: Node2D
@export var followerLabel: Label
@export var sanityBar: Node2D
@export var playerCamera: Camera2D
var bubbles: Dictionary
var followers: int:
	set(value):
		followers = value

		speed = 25+log(followers)*25
		followerLabel.text = "Followers: " + str(followers)
		playerCamera.zoom =Vector2(1,1)/(1+log(followers)/20)
	
var sanity: float = 100:
	set(value):
		if value <=0:
			get_tree().quit()
		sanity = clamp(value,0,100)
		sanityBar.sanity = value
		

@onready
var animation_player: AnimationPlayer = $Animated/AnimationPlayer
@onready
var animated: Node2D = $Animated
@onready
var animated_original_scale_x: float = animated.scale.x

@export var tweetButton: Button

func _ready():
	followers = 10
	tweetButton.tweet_received.connect(_on_tweet_received)
	var childNodes = $"..".get_children().filter(func(child): return child is StaticBody2D).filter(func(node): return node.collisionType == "BUBBLE")
	for node in childNodes:
		bubbles[node.topic] = node
	
func _on_button_send_impulse(impulseVector: Vector2) -> void:
	targetPosition = position + impulseVector

func _physics_process(delta: float) -> void:
	var move = Vector2(0, 0)
	
	if (position - targetPosition).length() > speed * delta:
		move = position.direction_to(targetPosition) * speed * delta
	else:
		tweetTarget.visible = false
		sanity -= 0.001 * followers
		position = targetPosition
		self.animation_player.stop(false)
	var collision = move_and_collide(move)
	if collision:
		var collider = collision.get_collider()
		if collider.collisionType == "HUMAN":
			sanity -=1
			followers += 5
			collider.queue_free()
		elif collider.collisionType == "BUBBLE":
			sanity = 0
		elif collider.collisionType == "MEME":
			sanity += 10
			collider.resetPosition()




func _on_tweet_received(id,text, result):
	
	var moveVector = Vector2(0, 0)
	for similarity in result:
		# Calculate movement vector delta
		var maxValue = 0
		if similarity.value > 0.3 and similarity.value > maxValue / 2.0:
			maxValue = similarity.value if similarity.value > maxValue else maxValue
			var bubble = bubbles[similarity.bubble]
			moveVector += position.direction_to(bubble.position) * (similarity.value*(250+speed+text.length()))
		
		# Send notifications
		bubbles[similarity.bubble].new_notification(similarity.value)
	targetPosition = position+ moveVector
	
	if targetPosition != self.position:
		var facing = -1 if targetPosition.x < self.position.x else 1
		self.animated.scale.x = facing * animated_original_scale_x
		self.animation_player.play("walk")
		tweetTarget.visible = true
		tweetTarget.position = targetPosition
		
	
