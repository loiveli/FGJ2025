extends Sprite2D

@onready var tween_offset = create_tween()
@onready var tween_opacity = get_tree().create_tween()

func _ready() -> void:
	self.self_modulate.a = 1.0
	
	tween_offset.tween_property(self, "position", Vector2(0, -40), 2)
	tween_opacity.tween_property(self, "self_modulate:a", 0, 2)
	
	# TODO: These are leaking memory
	

func _process(delta: float) -> void:
	pass
