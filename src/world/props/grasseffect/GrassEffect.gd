extends Node2D

# Access to the Animated Sprite
onready var _animatedSprite = $AnimatedSprite

# Play the GrassEffect animation when this scene/node is called
func _process(_delta: float) -> void:
	_animatedSprite.play("GrassEffect")

# Destroy the scene/node when the animation is finished
func _on_AnimatedSprite_animation_finished() -> void:
	queue_free()
