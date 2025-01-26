extends Label
func _ready() -> void:
	text = "0"

func _on_v_slider_value_changed(value:float) -> void:
	text = str(value)
