extends MarginContainer

signal win
signal lose

onready var hunger_progress = $VBoxContainer / CenterContainer / HungerProgress

export var hunger = 50 setget set_hunger
export var speed = 2

var hunger_proxy = hunger

const m_green = Color("4dc450")
const m_yellow = Color("FFE068")
const m_red = Color("e54c4c")


func _ready():
	hunger_progress.value = hunger * hunger_progress.max_value * 0.01


func _process(delta):
	if hunger <= 100:
		self.hunger -= speed * delta
	
	hunger_proxy = lerp(hunger_proxy, hunger, 0.01)
	hunger_progress.value = hunger_proxy * hunger_progress.max_value * 0.01
	if hunger > 50:
		hunger_progress.tint_progress = m_yellow.linear_interpolate(m_green, (hunger_proxy - 50) / 50.0)
	else:
		hunger_progress.tint_progress = m_red.linear_interpolate(m_yellow, hunger_proxy / 50.0)


func set_hunger(val):
	hunger = clamp(val, - 20, 200)
	
	if hunger > 100:
		emit_signal("win")
		hunger = 150
	
	if hunger_proxy < 0:
		emit_signal("lose")
