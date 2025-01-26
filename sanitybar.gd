extends Node2D


const MAX_SANITY: float = 100.0
@export var sanity: float = 100.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"./TextureRect".material.set_shader_parameter("sanity", sanity)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"./TextureRect".material.set_shader_parameter("sanity", sanity)
	pass
