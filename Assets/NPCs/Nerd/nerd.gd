extends Node2D

@onready var label: Label = get_node('Label')
var player_in_area: bool = false
var carta_ja_entregue: bool = false

func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("interacao"):
		if Global.entregar_carta == true:
			var Nerd = Dialogic.start('NerdCarta')#Diálogo entregando a Carta
			add_child(Nerd)
			if carta_ja_entregue == false:
				Global.cartas_entregues_label -= 1
				carta_ja_entregue = true
			Global.cartas_entregues += 1
			if Global.cartas_entregues == 7:
				Global.cartas_ja_entregues = true
		else:
			var Nerd = Dialogic.start('nerd')#Diálogo comun
			add_child(Nerd)
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
