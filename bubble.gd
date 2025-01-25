extends StaticBody2D

var followers: int = 0:
	set(value):
		followers = value
		scale = Vector2(1 + (followers / 20.0),1 + (followers / 20.0))


var permanent_person_scene = preload("res://people/permanent_person.tscn")
var temporary_person_scene = preload("res://people/temporary_person.tscn")

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
	
@export var bubble: String
