extends AnimatedSprite

# Play the Death Effect animation
func _ready() -> void:
	# Connect the anidmation_finished signal to the object/node
	
	# connect the object/node that has the signal, the signal to connect to
	# the object/node that has the function, the function that we're connecting to
# warning-ignore:return_value_discarded
	self.connect("animation_finished", self, "_on_animation_finished")
	
	# Set the starting animation frame
	frame = 0
	
	# Play the animation
	play("Animation")

# Destroy the object/node when the animation is finished
func _on_animation_finished() -> void:
	queue_free()
