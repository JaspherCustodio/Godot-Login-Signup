extends Control


func _ready() -> void:
	await (get_tree().create_timer(3).timeout)
	queue_free()
