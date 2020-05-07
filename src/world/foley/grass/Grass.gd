extends StaticBody2D

const _GrassEffect: = preload("GrassDeathEffect.tscn")

func create_grass_effect() -> void:
	# Load the grass effect scene and create the instance of the scene
	var _grassEffect = _GrassEffect.instance()
	
	# Get the main scene from the tree scene and add a child
	# grass effect instace at the same position of this grass node
	var _Game = get_tree().current_scene
	_Game.add_child(_grassEffect)
	_grassEffect.global_position = global_position


# Create grass effect when grass hurtbox is entered and destroy the node
func _on_Hurtbox_area_entered(_area: Area2D) -> void:
	# Create grass effect
	create_grass_effect()
	# Destroy the node
	queue_free()
