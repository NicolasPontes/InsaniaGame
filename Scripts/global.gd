extends Node

#Dialogo Inicio
var dialogo_inicio: bool = false

#Variávei do sistema de entrega de cartas
var carta_pega: bool
var entregar_carta: bool
var cartas_entregues: int
var cartas_entregues_label: int = 7
var carta_destruida: bool = false

#para de e atacar pular na escola
var juca_escola : bool

#Ir embora Após entregar cartas
var cartas_ja_entregues : bool = false

#Atualizar a Vida e Ultimate
var player_vida_max: int = 100
var player_vida: int = player_vida_max
var load_ultimate: int = 0


#Boss
var boss_morto: bool = false

#Task
var casa_juca: bool = false
