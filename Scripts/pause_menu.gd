extends CanvasLayer

@onready var resume_btn: Button = $MarginContainer/VBoxContainer/resume_btn

func _ready():
	visible = false


func _process(delta):
	pass


func  _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true


func _on_resume_btn_pressed():
	get_tree().paused = false
	visible = false

func _on_quit_btn_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Cenas/menu.tscn")
