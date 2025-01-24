extends Button

var xSpeed: float
var ySpeed: float

signal send_impulse(impulseVector: Vector2)

func _on_v_slider_value_changed(value:float) -> void:
	ySpeed = value


func _on_h_slider_value_changed(value:float) -> void:
	xSpeed = value


func _on_pressed() -> void:
	send_impulse.emit(Vector2(xSpeed,-ySpeed)*500)
