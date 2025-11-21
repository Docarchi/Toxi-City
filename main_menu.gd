extends MarginContainer


func _on_button_pressed() -> void:
	var game_scene = load("res://level.tscn")
	get_tree().change_scene_to_packed(game_scene)
