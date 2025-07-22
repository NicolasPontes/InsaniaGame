extends Node2D

func _ready():
	Global.player_vida = 100
	Global.load_ultimate = 0

func _on_sair_pressed() -> void:
	get_tree().quit()

func _on_reiniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/casa_juca.tscn")
