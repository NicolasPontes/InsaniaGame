extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]
@onready var sprite: Sprite2D = $Sprite2D
@onready var base_colision_area: CollisionShape2D = $BaseAttackArea/BaseAttackColision
@onready var strong_colison_area: CollisionShape2D = $StrongAttackArea/StrongAttackCollision

@export var follow_speed: float = 100.0  # Velocidade do inimigo
@export var stop_distance: float = 320.0  # Distância mínima entre inimigo e player
@export var detection_range: float = 800.0  # Raio de detecção para ativar perseguição
@export var VIDA_MAX = 10
@export var DANO = 10
@export var ULTIMATE_DANO = 20

# Referência para o player
var player: Node2D
var is_chasing: bool = false  # Flag para indicar se o inimigo está perseguindo
var is_attacking: bool = false
var is_dead: bool = false
var take_hit: bool = false
var vida: int = VIDA_MAX

const NUMERO_COLLISION = -166


func _ready():
	player = get_parent().get_node("Player") # Encontre o player


func _process(delta: float):
	if is_dead or take_hit:
		return
	if player:
		# Verifica se o player está dentro do range de detecção
		if not is_chasing and position.distance_to(player.position) <= detection_range:
			is_chasing = true  # Comece a perseguir o player
		if is_chasing and not is_attacking:
			perseguir(delta)
			flip()


func perseguir(delta: float):
	var distance_to_player = position.distance_to(Vector2(player.position.x, position.y))
	if distance_to_player > stop_distance:
		state_machine.travel("run")
		var direction = Vector2(player.position.x - position.x, 0).normalized()
		velocity = direction * follow_speed
	else:
		velocity = Vector2.ZERO
		if not is_attacking:
			state_machine.travel("base_attack")
		
	move_and_slide()


func flip():
	if player.position.x < position.x:
		sprite.scale.x = abs(sprite.scale.x)  #Player na esquerda
		base_colision_area.position.x = NUMERO_COLLISION
	else:
		sprite.scale.x = -abs(sprite.scale.x) #Player na direita
		base_colision_area.position.x = -NUMERO_COLLISION


func strong_attack():
	if not is_attacking:
		is_attacking = true
		var chance = randf()
		if chance <= 0.25:
			print("Ativando strong_attack...")
			animation_tree.set("parameters/conditions/can_ultimate", true)
			
			await get_tree().create_timer(0.7).timeout
			animation_tree.set("parameters/conditions/can_ultimate", false)
			print("Desativando can_ultimate")
		is_attacking = false


func _on_base_attack_area_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(DANO)
		
		# Determina a direção do knockback (invertida para o lado inicial do inimigo)
		var knockback_direction = Vector2(1 if position.x < body.position.x else -1, 0)
		var knockback_strength = 80.0  # Ajuste a força do knockback
		
		# Aplica o knockback ao player
		if body.has_method("apply_knockback"):
			body.apply_knockback(knockback_direction * knockback_strength)


func _on_strong_attack_area_body_entered(body):
	body.take_damage(ULTIMATE_DANO)


func take_damage(amount: int):
	if is_dead:
		return
	vida -= amount
	if vida<= 0:
		die()
	else:
		take_hit = true
		state_machine.travel("hit")

func finish_hit(): 
	take_hit = false
	

func die():
	Global.boss_morto = true
	is_dead = true
	velocity = Vector2.ZERO
	state_machine.travel("death")
