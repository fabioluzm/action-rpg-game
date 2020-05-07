extends StaticBody2D

const _GRASSEFFECT: = preload("GrassDeathEffect.tscn")

func create_grass_effect() -> void:
	# Load the grass effect scene and create the instance of the scene
	var grassEffect = _GRASSEFFECT.instance()
	
	# Attach the instace at the same position of the parent node
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position


# Create grass effect when grass hurtbox is entered and destroy the node
func _on_Hurtbox_area_entered(_area: Area2D) -> void:
	# Create grass effect
	create_grass_effect()
	# Destroy the node
	queue_free()
