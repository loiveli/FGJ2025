extends RigidBody2D

var targetPosition: Vector2 = position



func _on_button_send_impulse(impulseVector:Vector2) -> void:
    targetPosition = position + impulseVector


func _process(delta: float) -> void:
    if (position - targetPosition).length() >10:
        position += position.direction_to(targetPosition)*25*delta