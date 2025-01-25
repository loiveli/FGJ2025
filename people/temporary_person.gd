extends RigidBody2D

func _ready():
	var timer := Timer.new()
	
	var timer_mean = 2.0
	var timer_delta = randf_range(-1.0, 1.0)
	
	timer.wait_time = timer_mean + timer_delta
	timer.one_shot = true

	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_death_timer_timeout"))
	timer.start()

func _on_death_timer_timeout():
	queue_free()
