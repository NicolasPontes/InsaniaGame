extends NinePatchRect

@onready var text_dialog_box = get_node('textDialogBox')
@onready var timer = get_node("Timer")

var msg_queue: Array = [
	'Oi, Tudo bem?',
	'Tudo sim, isto é um teste de texto para a caixa de diálogo para usarmos de exemplo.'
]

func _ready() -> void:
	if not text_dialog_box is RichTextLabel:
		print("Erro: text_dialog_box não é um RichTextLabel")
		return
	if text_dialog_box == null:
		print("Erro: text_dialog_box não foi encontrado!")
		return

		

func _input(event) -> void:
	if event is InputEventKey or event.is_action_pressed("ui_accept"):
		show_message()

func show_message() -> void:
	if msg_queue.size() == 0:
		hide()
		return
	
	var _msg: String = msg_queue.pop_front()
	text_dialog_box.visible_characters = 0
	text_dialog_box.bbcode_text = _msg  # Usando bbcode_text corretamente
	timer.start()

func _on_timer_timeout() -> void:
	if text_dialog_box.visible_characters == text_dialog_box.bbcode_text.length():
		timer.stop()
	else:
		text_dialog_box.visible_characters += 1
