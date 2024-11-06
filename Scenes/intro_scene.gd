extends Control


func _ready() -> void:
	await (get_tree().create_timer(5).timeout)
	SceneSwitcher.switch_scene("res://Scenes/login_screen.tscn")
