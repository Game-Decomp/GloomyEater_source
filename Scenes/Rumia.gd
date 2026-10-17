extends Node2D

signal ate
signal finish_eat

onready var eyes = $Base / Eyes
onready var mouth = $Base / Mouth
onready var eat_area = $EatArea
onready var anim_tree = $AnimationTree
onready var pet_mecha = $Node2D

func _ready():
	anim_tree.active = true


func now_sad():
	anim_tree.get("parameters/Eat_state/playback").travel("sad")


func now_happy_end():
	anim_tree.get("parameters/Eat_state/playback").travel("happy_end")


func now_angy():
	anim_tree.get("parameters/Eat_state/playback").travel("angy")


func _on_EatArea_area_entered(area):
	if eat_area.collision_mask != area.collision_layer or mouth.frame != 0:
		return
	
	
	area.get_parent().queue_free()
	anim_tree.get("parameters/Eat_state/playback").travel("eat_Loop")
	emit_signal("ate")
	eat_area.set_deferred("monitoring", false)
	
	$EatTimer.start()
	


func _on_EatTimer_timeout():
	if pet_mecha.isPet:
		anim_tree.get("parameters/Eat_state/playback").travel("pet")
	else:
		anim_tree.get("parameters/Eat_state/playback").travel("blank")
	
	eat_area.set_deferred("monitoring", true)
	emit_signal("finish_eat")


func _on_BlinkTimer_timeout():
	var current_node = anim_tree.get("parameters/Eat_state/playback").get_current_node()
	
	if current_node == "blank":
		$AnimationTree.set("parameters/Blink/active", true)
	$BlinkTimer.start(rand_range(3, 15))


func _on_Node2D_pet():
	var current_node = anim_tree.get("parameters/Eat_state/playback").get_current_node()
	
	if current_node == "blank":
		anim_tree.get("parameters/Eat_state/playback").travel("pet")


func _on_Node2D_stop():
	var current_node = anim_tree.get("parameters/Eat_state/playback").get_current_node()
	
	if current_node == "pet":
		anim_tree.get("parameters/Eat_state/playback").travel("pet_finish")
