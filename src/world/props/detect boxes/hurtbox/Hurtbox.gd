extends Area2D

export var _show_hit: = true

const _HitEffect = preload("../../hit effect/HitEffect.tscn")

func _on_Hurtbox_area_entered(area: Area2D) -> void:
	if _show_hit == true:
		var _effect = _HitEffect.instance()
		var _main = get_tree().current_scene
		_main.add_child(_effect)
		_effect.global_position = global_position
