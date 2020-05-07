extends Area2D

# variables
var _player: = null

func _physics_process(delta: float) -> void:
	pass

func can_see_player() -> bool:
	return _player != null

func _on_PlayerDetection_body_entered(body: Node) -> void:
	_player = body


func _on_PlayerDetection_body_exited(body: Node) -> void:
	_player = null
