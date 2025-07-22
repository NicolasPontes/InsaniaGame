extends CanvasLayer

var sem_carta: bool = false

@onready var health_bar: ProgressBar = $Control/MarginContainer/HBoxContainer/HealthBar
@onready var ultimate_bar: ProgressBar = $Control/MarginContainer/HBoxContainer/UltimateBar
@onready var sanidade_label = $Control/MarginContainer/HBoxContainer/HealthBar/SanidadeLabel
@onready var insanidade_label = $Control/MarginContainer/HBoxContainer/UltimateBar/InsanidadeLabel
@onready var control = $Control
@onready var qtdCarta = $QtdCarta
@onready var itemCarta = $ItemCarta
@onready var tasks = $MissaoLabel/Tasks


func _process(delta):
	health_bar.value = Global.player_vida
	ultimate_bar.value = Global.load_ultimate
	if Global.juca_escola == false:
		control.visible = false
	
	if Global.casa_juca:
		if is_instance_valid(tasks):
			tasks.text = 'Interaja com os móveis'
	
	if Global.juca_escola:
		control.visible = true
		if is_instance_valid(tasks):
			tasks.text = 'Derrote o Boss StaticMan'

	if Global.carta_pega == true and sem_carta == false:
		qtdCarta.visible = true
		itemCarta.visible = true
		if is_instance_valid(tasks):
			tasks.text = 'Entregue as cartas para os seus colegas'
	if is_instance_valid(qtdCarta):
		qtdCarta.text = str(Global.cartas_entregues_label)
	if Global.cartas_entregues_label == 0:
		if is_instance_valid(tasks):
			tasks.text = 'Saia da escola pela secretaria'  # Verifica se a quantidade é zero
		if is_instance_valid(qtdCarta):
			qtdCarta.queue_free()
			sem_carta = true
		if is_instance_valid(itemCarta):
			itemCarta.queue_free()
			sem_carta = true
