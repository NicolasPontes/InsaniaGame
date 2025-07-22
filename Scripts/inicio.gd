extends Node2D

var dialogo_feito: bool = false
var começar: bool = false
var acontecendo: bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if começar and acontecendo!=true:
		Dialogic.timeline_ended.connect(_on_timeline_ended)
		var Inicio = Dialogic.start('Inicio')
		acontecendo = true
		add_child(Inicio)
	
func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended) 	
	get_tree().change_scene_to_file("res://Cenas/sala_de_aula.tscn")
	acontecendo = false


func _on_timer_timeout() -> void:
		começar = true
