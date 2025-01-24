extends RigidBody2D


func _on_button_send_impulse(impulseVector:Vector2) -> void:
	self.apply_impulse(impulseVector)
