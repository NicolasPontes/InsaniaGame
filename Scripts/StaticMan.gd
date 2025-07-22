extends CharacterBody2D

@onready var animation = $Animation
@onready var ray = $Ray
@onready var attack_colision: CollisionShape2D = $AttackArea/Attack_Colision
@onready var area_perseguicao = $AreaPerseguicao # Área de perseguição do player
@onready var ultimateCD: Timer = $ultimateCD #Timer da ultimate do boss
@onready var attackCD: Timer = $attackCD

@export var tempo_idle: float = 2.0
@export var distancia_patrulha: float = 0.2
@export var direction : = -10

const VIDA_MAX = 10
const DANO = 0
const ULTIMATE_DANO = 5
const NUMERO_COLLISION = -163.682

var SPEED = 0
var atacando: bool
var vida: int = VIDA_MAX
var is_dead: bool = false
var levando_hit: bool = false
var usar_ultimate: bool = false
var pode_atacar: bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Estados do inimigo
enum Estado { PATRULHANDO, IDLE, PERSEGUINDO, ULTIMATE }
var estado_atual = Estado.PATRULHANDO

# Temporizador para o estado de idle
var temporizador_idle = 0.0
var andando_para_a_direita: bool = true
var posicao_inicial: Vector2

# Refêrencia ao jogador
var jogador: Node2D = null

func _ready():
	ultimateCD.start(10.0)

func _physics_process(delta):
	if is_dead or levando_hit:
		return
	# Adiciona Gravidade.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Gerenciar os estados
	match estado_atual:
		Estado.PATRULHANDO:
			patrulhar(delta)
		Estado.IDLE:
			ficar_idle(delta)
		Estado.PERSEGUINDO:
			perseguir_jogador(delta)
		Estado.ULTIMATE:
			ultimate()

func set_estado(novo_estado: Estado):
	if estado_atual == novo_estado:
		return
	estado_atual = novo_estado
	match novo_estado:
		Estado.PATRULHANDO:
			animation.play("run")
		Estado.IDLE:
			animation.play("idle")
			velocity = Vector2.ZERO
		Estado.PERSEGUINDO:
			animation.play("run")
		Estado.ULTIMATE:
			animation.play("ultimate")


# FUNÇÕES DE ESTADO
func patrulhar(_delta):
	if ray.is_colliding():
		direction *= -1
		ray.scale.x *= -1
		fliph()
		
	SPEED = 20.0
	velocity.x = direction * SPEED
	animation.play("run")
	
	move_and_slide()
	
	if andando_para_a_direita and global_position.x >= posicao_inicial.x + distancia_patrulha:
		andando_para_a_direita = false
		mudar_para_idle()
	elif not andando_para_a_direita and global_position.x <= posicao_inicial.x - distancia_patrulha:
		andando_para_a_direita = true
		mudar_para_idle()
		
func mudar_para_idle():
	estado_atual = Estado.IDLE
	temporizador_idle = 0.0
	velocity.x = 0
	animation.play("idle")
	
func ficar_idle(delta):
	temporizador_idle += delta
	if temporizador_idle >= tempo_idle:
		estado_atual = Estado.PATRULHANDO
		animation.play("run")

func _on_area_perseguicao_body_entered(body):
	if body.is_in_group("player"):
		jogador = body
		estado_atual = Estado.PERSEGUINDO
		animation.play("run")
		
func _on_area_perseguicao_body_exited(body):
	if body.is_in_group("player"):
		jogador = null
		estado_atual = Estado.PATRULHANDO
		animation.play("run")

func perseguir_jogador(_delta):
	SPEED = 110.0
	if jogador:
		var direcao_para_jogador = (jogador.global_position - global_position).normalized()
		velocity.x = direcao_para_jogador.x * SPEED
		move_and_slide()
		flipD()

func ultimate():
	if ultimateCD.timeout:
		velocity = Vector2.ZERO
		animation.play("ultimate")
		ultimateCD.start(10.0)	#Reinicia o timer
	else:
		set_estado(Estado.PERSEGUINDO) 



#FUNÇÕES DE DIREÇÃO
func fliph(): #Muda a direção do boss	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
		$AttackArea/Attack_Colision.position.x = NUMERO_COLLISION
		$UltimateArea/UltimateColision.position.x = NUMERO_COLLISION
	if velocity.x < 0:
		$Sprite2D.flip_h = true
		$AttackArea/Attack_Colision.position.x = -NUMERO_COLLISION
		$UltimateArea/UltimateColision.position.x = -NUMERO_COLLISION

func flipD(): #Muda a dirção do boss quando esta em estado de Perseguindo
	if velocity.x > 0:
		$Sprite2D.flip_h = true
		$AttackArea/Attack_Colision.position.x = -NUMERO_COLLISION
		$UltimateArea/UltimateColision.position.x = -NUMERO_COLLISION
	if velocity.x < 0:
		$Sprite2D.flip_h = false
		$AttackArea/Attack_Colision.position.x = NUMERO_COLLISION
		$UltimateArea/UltimateColision.position.x = NUMERO_COLLISION



#FUNÇÕES DE ENTRAR E SAIR DA AREA DE ATAQUE
func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		pode_atacar = false
		atacando = true
		animation.play("attack")
		
func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		atacando = false
		animation.play("run")



#FUNÇÕES PARA CAUSAR DANO
func _on_attack_area_body_entered(body):
		body.take_damage(DANO)

func _on_ultimate_area_body_entered(body):
		body.take_damage(ULTIMATE_DANO)



func _on_animation_finished(anim_name):
	if is_dead:
		animation.play("death")
		queue_free()
		return
	if anim_name == "attack":
		if atacando:
			animation.play("attack")
		else:
			animation.play("run")
	if anim_name == "ultimate":
		if usar_ultimate:
			animation.play("ultimate")
		else:
			animation.play("run")
	elif anim_name == "hit":
		levando_hit = false
		if atacando:
			animation.play("attack")
		else:
			animation.play("run")

func take_damage(amount: int):
	if is_dead:
		return
	vida -= amount
	if vida<= 0:
		die()
	else:
		levando_hit = true
		animation.play("hit")
		
func die():
	is_dead = true
	ultimateCD.queue_free()
	animation.play("death")
	velocity = Vector2.ZERO

func _on_ultimate_cd_timeout():
	usar_ultimate = true
	if usar_ultimate == true:
			usar_ultimate = false
			animation.play("ultimate")	
