extends Node2D

func _on_sair_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/menu.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		get_tree().change_scene_to_file("res://Cenas/menu.tscn")
