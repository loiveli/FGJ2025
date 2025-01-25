extends StaticBody2D

var permanent_person_scene = preload("res://people/permanent_person.tscn")
var temporary_person_scene = preload("res://people/temporary_person.tscn")
var heart_notification = preload("res://heart_notification.tscn")
var poop_notification = preload("res://poop_notification.tscn")
var current_notification = null

func _ready():
	# Add 30 permanent people around the bubble
	for i in range(30):
		var permanent_person_instance = permanent_person_scene.instantiate()
		permanent_person_instance.position = _get_person_coordinates()
		add_child(permanent_person_instance)
		
	# Add timer that creates temporary people every now and then
	$PersonTimer.connect("timeout", Callable(self, "_on_person_timer_timeout"))

func _get_person_coordinates() -> Vector2:
	# Create a rotation and a distance,
	# then translate the resulting polar coordinates
	# to Cartesian coordinates.q
	var theta = randf() * 2 * PI
	var min_distance = 60
	var max_distance = 90
	var distance = min_distance + randf() * (max_distance - min_distance)
	var x = distance * cos(theta)
	var y = distance * sin(theta)
	
	return Vector2(x, y)

func _on_person_timer_timeout():
	var temporary_person_instance = temporary_person_scene.instantiate()
	temporary_person_instance.position = _get_person_coordinates()
	add_child(temporary_person_instance)
	
func new_notification(similarity: float):
	if current_notification:
		remove_child(current_notification)
	
	var new_notifier = heart_notification.instantiate() if similarity > 0.3 else poop_notification.instantiate()

	add_child(new_notifier)
	current_notification = new_notifier
	
@export var bubble: String 
