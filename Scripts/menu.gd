extends Node2D

@onready var animation: AnimationPlayer = get_node('AnimationTv')
@onready var animationRednic: AnimationPlayer = get_node('AnimationRednic')
@onready var animationBg: AnimationPlayer = get_node('AnimationBg')
@onready var telaPreta: ColorRect = get_node('hud/TelaPreta')
@onready var logoRednic: TextureRect = get_node('hud/CenterContainer/Logo')

var contagem : int = 0

func _process(delta: float) -> void:
	
	if contagem == 0:
		contagem += 1
		animationRednic.play('inicio')
	animation.play('estatica')
	animationBg.play('bg')
	
func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/inicio.tscn")
	

func _on_sair_pressed() -> void:
	get_tree().quit()


func _on_animation_rednic_animation_finished(anim_name: StringName) -> void:
	telaPreta.position.x = 3000
	logoRednic.position.x = 3000
	

	
