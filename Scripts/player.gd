extends CharacterBody2D

@export var speed = 80.0
@export var jump_velocity = 410.0
@export var dano = 0 #Dano causado ao inimigo
@export var ultimate_dano = 500 #Dano para finalizar o inimigo

@onready var collision: CollisionShape2D = $Collision

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: = $Sprite2D
@onready var ultimate_area: Area2D = $UltimateArea
@onready var timer: = $Timer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: float
var atacando: bool
var ultando: bool = false
var is_dead: bool = false
var levando_hit: bool = false
var is_knocked_back: bool = false

const NUMERO_COLLISION = -233


func _process(_delta):
	if is_dead:
		return
	animate()
	fliph()
	
	
func fliph():
	if velocity.x > 0:
		$Sprite2D.flip_h = true
		$UltimateArea/CollisionUltimate.position.x = -NUMERO_COLLISION
		$AttackArea/ColisionAttack.position.x = 97
		if atacando:
			collision.position.x = -122
	if velocity.x < 0:
		$Sprite2D.flip_h = false
		collision.position.x = 0
		$UltimateArea/CollisionUltimate.position.x = NUMERO_COLLISION
		$AttackArea/ColisionAttack.position.x = -203

func animate():
	if is_dead:
		animation.play("death")
		return
	if ultando:
		animation.play("ultimate")
		return
	elif atacando:
		if velocity.x > 0:
			collision.position.x = -122
		animation.play("attack")
		return
	elif levando_hit:
		animation.play("hit")
		return
	if velocity.y > 0 and not is_on_floor():
		animation.play("jump")
		return
	if velocity.y < 0 and not is_on_floor():
		animation.play("fall")
		return
	if velocity.x != 0:
		animation.play("run")
		return
	if velocity.x == 0:
		animation.play("idle")
		return
	
func _physics_process(delta):
	if is_dead:
		return
	
	if is_knocked_back:
		# Gradualmente reduz a velocidade do knockback até parar
		velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
		if velocity.length() < 10:
			is_knocked_back = false
	else:
		gravidade(delta)
		mover()
		
	move_and_slide()
	
	
func _input(_event: InputEvent):
	if is_dead:
		return
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	if Input.is_action_just_pressed("attack"):
		ataque()
	elif Input.is_action_just_pressed("ultimate"):
		ultimate()
	direction = Input.get_axis("left","right")
	
func mover():
	velocity.x = direction * speed
	move_and_slide()
	
func gravidade(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func jump():
	if Global.juca_escola == false:
		return
	if is_knocked_back:
		return   
	velocity.y = -jump_velocity

func ataque():
	if Global.juca_escola == false:
		return
	atacando = true
	
	
func ultimate():
	if Global.juca_escola == false:
		return
	elif Global.load_ultimate >= 100:
		ultando = true
	else:
		return
	
func _on_animation_finished(anim_name):
	if anim_name == "attack":
		atacando = false
		collision.position = Vector2(0,0)
	if anim_name == "ultimate":
		ultando = false
		Global.load_ultimate = 0
	if anim_name == "death":
		timer.start()
	if anim_name == "hit":
		levando_hit = false
		
func take_damage(amount: int):
	if is_dead:
		return
	
	Global.player_vida -= amount
	if Global.player_vida <= 0:
		die()
	else:
		levando_hit = true
		animation.play("hit")
		
func die():
	is_dead = true
	velocity = Vector2.ZERO
	animation.play("death")

func _on_timer_timeout():
	get_tree().change_scene_to_file('res://Cenas/game_over.tscn')

func apply_knockback(knockback_force: Vector2):
	if is_knocked_back:
		return
	velocity += knockback_force
	is_knocked_back = true

func _on_ultimate_area_body_entered(body):
	if body.is_in_group("inimigo") and ultando:
		body.take_damage(ultimate_dano) #causa dano ao inimigo


func _on_attack_area_body_entered(body):
	if body.is_in_group("inimigo") and atacando:
		body.take_damage(dano) #causa dano ao inimigo
		Global.load_ultimate += 10
		
