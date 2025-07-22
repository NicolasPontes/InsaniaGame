extends Node2D

var player_in_area : bool = false
var v : bool = true
@onready var Transition: AnimationPlayer = $transition/AnimationPlayer

func _ready() -> void:
	Transition.play('FadeOut')
	if Global.dialogo_inicio == false:
		var InicioSalaJuca = Dialogic.start('InicioSalaAula')#Diálogo entregando a Carta
		add_child(InicioSalaJuca)
		Global.dialogo_inicio = true

func _process(delta: float) -> void:
	if v:
		Global.juca_escola = false
	if player_in_area and Input.is_action_just_pressed("interacao"):
		Transition.play('FadeIn')
	pass

func _on_porta_body_entered(body: Node2D) -> void:
	player_in_area = true


func _on_porta_body_exited(body: Node2D) -> void:
	player_in_area = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if player_in_area:
		get_tree().change_scene_to_file("res://Cenas/level.tscn")
