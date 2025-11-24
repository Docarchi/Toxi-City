extends MarginContainer


func _on_button_pressed() -> void:
	var game_scene = load("res://level.tscn")
	get_tree().change_scene_to_packed(game_scene)


func _on_button_3_pressed() -> void:
	$Credits.show()


func _on_b_credits_back_pressed() -> void:
	$Credits.hide()


func _on_b_rules_back_pressed() -> void:
	$Rules.hide()


func _on_button_2_pressed() -> void:
	$Rules.show()
