extends RigidBody2D

@export var personAnimation: AnimationPlayer

func _ready():
	var timer := Timer.new()
	var timer_mean = 5
	var timer_delta = randf_range(-1, 1)
	
	timer.wait_time = timer_mean + timer_delta
	timer.one_shot = true

	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_death_timer_timeout"))
	timer.start()


func _on_death_timer_timeout():
	queue_free()
