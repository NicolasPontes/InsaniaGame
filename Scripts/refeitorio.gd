extends Node2D

var player_in_area: bool = false
var area_carta: bool = false
@onready var label: Label = $Label
@onready var carta: Sprite2D = $carta
@onready var luz_carta: Sprite2D = $Luz5
@onready var Transition: AnimationPlayer = $transition/AnimationPlayer

func _ready():
	Transition.play('FadeOut')
	# Verifica se a carta foi destruída anteriormente
	if Global.carta_destruida:
		carta.queue_free()
		luz_carta.queue_free()
		label.queue_free()

func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("interacao"):
		Transition.play('FadeIn')
	if area_carta and Input.is_action_just_pressed("interacao"):
		carta.queue_free()
		luz_carta.queue_free()
		Global.carta_destruida = true
		Global.carta_pega = true
		Global.entregar_carta = true
		var cartaPega = Dialogic.start('PegarCarta')
		add_child(cartaPega)
func _on_area_2d_2_body_entered(body: Node2D) -> void:
	print(body)
	player_in_area = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		area_carta = true
		label.visible = true
		print(carta)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == 'Player':
		area_carta = false
		label.visible = false

func _on_area_2d_2_body_exited(body: Node2D) -> void:
	player_in_area = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if player_in_area:
		get_tree().change_scene_to_file("res://Cenas/level.tscn")
