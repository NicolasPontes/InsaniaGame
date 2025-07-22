extends Node2D

var juca_sofa: bool = false
var juca_planta: bool = false
var juca_poltrona: bool = false

var c: int = 0

var interagir_juca_sofa: bool = false
var interagir_juca_planta: bool = false
var interagir_juca_poltrona: bool = false

var entrou_final = true

@onready var cor_fundo : CanvasModulate = $CanvasModulate
@onready var Transition: AnimationPlayer = $transition/AnimationPlayer
@onready var Piscar: AnimationPlayer = $AnimacaoSala
@onready var Rodar: AnimationPlayer = $AnimacaoRelogio
@onready var luz: AnimationPlayer = $luz2
@onready var cena_boss = load('res://Cenas/static_man.tscn')
@onready var objeto_instancia = cena_boss.instantiate()
@onready var music: AudioStreamPlayer = $Ambiente
@onready var musicBoss: AudioStreamPlayer = $boss
@onready var sofa: Area2D = $Sofa
@onready var planta: Area2D = $Planta
@onready var poltrona: Area2D = $Poltrona
@onready var juca: CharacterBody2D = $Player
@onready var hud: CanvasLayer = $HUD

func _ready() -> void:
	Global.casa_juca = true
	var inicio = Dialogic.start('LarDoceLar')
	add_child(inicio)
	Transition.play('FadeOut')


func _process(delta: float) -> void:
	if juca_sofa and Input.is_action_just_pressed("interacao") and not interagir_juca_sofa:
		interagir_juca_sofa = true
		c += 1
		var Dsofa = Dialogic.start('sofa')
		add_child(Dsofa)
		
	if juca_sofa and Input.is_action_just_pressed("interacao") and c == 3:
		sofa.queue_free()
		planta.queue_free()
		poltrona.queue_free()
		comecar()
	if juca_planta and Input.is_action_just_pressed("interacao") and not interagir_juca_planta:
		interagir_juca_planta = true
		c += 1
		var Dplanta = Dialogic.start('planta')
		add_child(Dplanta)

	if juca_poltrona and Input.is_action_just_pressed("interacao") and not interagir_juca_poltrona:
		interagir_juca_poltrona = true
		c += 1
		var Dpoltrona = Dialogic.start('Poltrona')
		add_child(Dpoltrona)
	
	if Global.boss_morto and entrou_final:
		Global.juca_escola = false
		entrou_final = false
		var finalJuca = Dialogic.start('finalJuca')
		add_child(finalJuca)
		
		
func comecar():
	Dialogic.signal_event.connect(_on_dialogic_signal)
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	var Dialogo = Dialogic.start('JucaNaCasaNinguemApareceu')
	add_child(Dialogo)
	

func _on_dialogic_signal(argument: String):
	if argument == "Piscar":
		Rodar.play('Rodando')
		Piscar.play('Piscando')
	
	if argument == 'Primeira_parte':
		juca.queue_free()
		hud.queue_free()  
		cor_fundo.color = Color8(0,0,0)
		luz.play('luz')
		var encerramento = Dialogic.start('encerramentoJuca')
		add_child(encerramento)
	if argument == 'encerramento':
		get_tree().change_scene_to_file("res://Cenas/creditos.tscn")
	
func _on_timeline_ended():
	Piscar.stop()
	musicBoss.playing = true
	music.playing = false
	cor_fundo.color = Color8(171,171,171)
	add_child(objeto_instancia)
	if is_instance_valid(objeto_instancia):
		objeto_instancia.position = Vector2(814, 701)
	Global.juca_escola = true

func _on_sofa_body_entered(body: Node2D) -> void:
	juca_sofa = true

func _on_sofa_body_exited(body: Node2D) -> void:
	juca_sofa = false

func _on_planta_body_entered(body: Node2D) -> void:
	juca_planta = true

func _on_planta_body_exited(body: Node2D) -> void:
	juca_planta = false

func _on_poltrona_body_entered(body: Node2D) -> void:
	juca_poltrona = true

func _on_poltrona_body_exited(body: Node2D) -> void:
	juca_poltrona = false
