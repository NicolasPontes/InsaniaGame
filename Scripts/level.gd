extends Node2D

var player_in_area: bool = false
var player_in_area_sala: bool = false
var player_in_area_saida: bool = false
var player_in_area_sala_trancada: bool = false
var v : bool = true
@onready var player: CharacterBody2D = $Player
@onready var saida: Area2D = $Saida
@onready var Labelsaida: Label = $LabelSaida
@onready var Transition: AnimationPlayer = $transition/AnimationPlayer
func _ready() -> void:
	Transition.play('FadeOut')

func _process(_delta):
	if v:
		Global.juca_escola = false
	if Global.cartas_ja_entregues:
		saida.collision_mask = 1
	if player_in_area and Input.is_action_just_pressed("interacao"):
		Transition.play('FadeIn')
	if player_in_area_saida and Input.is_action_just_pressed("interacao"):
		Transition.play('FadeIn')
	if player_in_area_sala and Input.is_action_just_pressed("interacao"):
		Transition.play('FadeIn')
	if player_in_area_sala_trancada and Input.is_action_just_pressed("interacao"):
		var Trancada = Dialogic.start('Portatrancada')
		add_child(Trancada)
		
func _on_area_2d_2_body_entered(body: Node2D) -> void:
	print(body)
	player_in_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
		player_in_area = false


func _on_saida_body_entered(body: Node2D) -> void:
	player_in_area_sala_trancada = false
	Labelsaida.visible = true
	player_in_area_saida = true


func _on_saida_body_exited(body: Node2D) -> void:
	Labelsaida.visible = false
	player_in_area_saida = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if player_in_area:
		get_tree().change_scene_to_file("res://Cenas/refeitorio.tscn")
	if player_in_area_saida:
		get_tree().change_scene_to_file("res://Cenas/casa_juca.tscn")
	if player_in_area_sala:
		get_tree().change_scene_to_file("res://Cenas/sala_de_aula.tscn")


func _on_sala_de_aula_body_entered(body: Node2D) -> void:
	player_in_area_sala = true
	
func _on_sala_de_aula_body_exited(body: Node2D) -> void:
	player_in_area_sala = false


func _on_sala_de_aula_2_body_entered(body: Node2D) -> void:
	player_in_area_sala_trancada = true



func _on_sala_de_aula_2_body_exited(body: Node2D) -> void:
	player_in_area_sala_trancada = false


func _on_sala_de_aula_3_body_entered(body: Node2D) -> void:
	player_in_area_sala_trancada = true



func _on_sala_de_aula_3_body_exited(body: Node2D) -> void:
	player_in_area_sala_trancada = false



func _on_sala_de_aula_4_body_entered(body: Node2D) -> void:
	player_in_area_sala_trancada = true



func _on_sala_de_aula_4_body_exited(body: Node2D) -> void:
	player_in_area_saida  = false
