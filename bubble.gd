extends StaticBody2D

var collisionType = "BUBBLE"

var followers: int = 0:
	set(value):
		followers = value
		scale = Vector2(1 + (followers / 20.0), 1 + (followers / 20.0))

# Limits of where people spawn around the bubble
var min_person_distance = 60
var max_person_distance = 90

# Size limits at which each enemy starts spawning
var bot_spawn_distance_threshold = 120
var troll_spawn_distance_threshold = 200

var bot_enemy_scene = preload("res://enemies/bot_enemy.tscn")
var permanent_person_scene = preload("res://people/permanent_person.tscn")
var temporary_person_scene = preload("res://people/temporary_person.tscn")
var heart_notification = preload("res://heart_notification.tscn")
var poop_notification = preload("res://poop_notification.tscn")
var current_notification = null

func _ready():
	# Add 30 permanent people around the bubble to begin with
	for i in range(50):
		var permanent_person_instance = permanent_person_scene.instantiate()
		permanent_person_instance.position = _get_person_coordinates(min_person_distance)
		add_child(permanent_person_instance)
		
	# Add timer that creates temporary people every now and then
	$PersonTimer.connect("timeout", Callable(self, "_on_person_timer_timeout"))
	
	# Add (stochastic) timer that spawns bots if size is large enough
	_create_bot_timer()
	
	
func _create_bot_timer():
	var bot_spawn_timer := Timer.new()
	var timer_mean = 30
	var timer_delta = randf_range(-10, 10)
	
	bot_spawn_timer.wait_time = timer_mean + timer_delta
	bot_spawn_timer.one_shot = true

	add_child(bot_spawn_timer)
	bot_spawn_timer.connect("timeout", Callable(self, "_on_bot_spawn_timer_timeout"))
	bot_spawn_timer.start()
	

func _on_bot_spawn_timer_timeout():
	if max_person_distance >= bot_spawn_distance_threshold:
		var new_bot_enemy = bot_enemy_scene.instantiate()
		add_child(new_bot_enemy)
	
	# Create a new timer (with a new duration)
	_create_bot_timer()

func _on_death_timer_timeout():
	queue_free()
	$PersonTimer.connect("timeout", Callable(self, "_on_person_timer_timeout"))

func _get_person_coordinates(min_person_distance) -> Vector2:
	# Create a rotation and a distance,
	# then translate the resulting polar coordinates
	# to Cartesian coordinates.
	var theta = randf() * 2 * PI
	var distance = min_person_distance + randf() * (max_person_distance - min_person_distance)
	var x = distance * cos(theta)
	var y = distance * sin(theta)
	
	return Vector2(x, y)

func _on_person_timer_timeout():
	# Add a temporary person at each interval
	var temporary_person_instance = temporary_person_scene.instantiate()
	temporary_person_instance.position = _get_person_coordinates(min_person_distance)
	add_child(temporary_person_instance)

	
func new_notification(similarity: float):
	if current_notification:
		remove_child(current_notification)
	
	var new_notifier = heart_notification.instantiate() if similarity > 0.3 else poop_notification.instantiate()

	add_child(new_notifier)
	current_notification = new_notifier
	
	# Kind of cursed, but let's also update the bubble size here while we're at it
	if similarity > 0.3:
		var previous_max_person_distance = max_person_distance
		max_person_distance += 10
		for i in range(20):
			var permanent_person_instance = permanent_person_scene.instantiate()
			permanent_person_instance.position = _get_person_coordinates(previous_max_person_distance)
			add_child(permanent_person_instance)
	
@export var bubble: String 
