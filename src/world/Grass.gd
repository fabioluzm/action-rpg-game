extends Node2D

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_attack"):	
		# Load the grass effect scene and create a instance of it
		var _GrassEffect: = load("res://src/world/props/grasseffect/GrassEffect.tscn") 
		var _grassEffect = _GrassEffect.instance()
		
		# Get the main scene from the tree scene and add a child
		# grass effect instace at the same position of this grass node
		var _Game = get_tree().current_scene
		_Game.add_child(_grassEffect)
		_grassEffect.global_position = global_position
		
		# destroy the node
		queue_free()
