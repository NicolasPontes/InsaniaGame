extends Node2D

@onready var label: Label = get_node('Label')
var player_in_area: bool = false

func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("interacao"):
		if Global.entregar_carta == true:
			var AgroBoy = Dialogic.start('AgroboyCarta')#Diálogo entregando a Carta
			add_child(AgroBoy)
			Global.cartas_entregues += 1
			if Global.cartas_entregues == 7:
				get_tree().change_scene_to_file("res://Cenas/casa_juca.tscn")
		else:
			var AgroBoy = Dialogic.start('Agroboy')
			add_child(AgroBoy)
		print("entrou")



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		player_in_area = true
		label.visible = true
		print(player_in_area)
	print(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == 'Player':
		player_in_area = false
		label.visible = false
