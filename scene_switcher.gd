extends Node

var current_scene = null

func _ready() -> void:
	var getroot = get_tree().root
	current_scene = getroot.get_child(getroot.get_child_count() - 1)

func switch_scene(res_path):
	call_deferred("_deffered_switch_scene", res_path)

func _deffered_switch_scene(res_path):
	current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
