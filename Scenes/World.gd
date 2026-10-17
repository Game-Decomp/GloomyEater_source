extends Node

onready var hunger_progress = $HungerBar
onready var food = $Food
onready var food_box = $FoodBox
onready var throw_sign = $ThrowSign

var first_grab = true
var first_throw = true

var my_timer = []

var is_pressed = false
var finish_init = false

func _ready():
	SoundManager.play_music()
	
	$Transition.show()
	$Transition.fade_out()
	yield(get_tree().create_timer(1), "timeout")
	
	if is_pressed:
		finish_init = true
		is_pressed = false
		back_to_title()
		return
	
	yield(get_tree().create_timer(1), "timeout")
	
	food.spawn_meat(Vector2(food_box.global_position.x, - 20))
	
	if is_pressed:
		finish_init = true
		is_pressed = false
		back_to_title()
		return
	
	yield(get_tree().create_timer(1), "timeout")
	
	if is_pressed:
		finish_init = true
		is_pressed = false
		back_to_title()
		return
	
	food.spawn_meat(Vector2(food_box.global_position.x, - 20))
	yield(get_tree().create_timer(1), "timeout")
	
	if is_pressed:
		finish_init = true
		is_pressed = false
		back_to_title()
		return
	
	yield(get_tree().create_timer(1), "timeout")
	
	finish_init = true
	
	if is_pressed:
		finish_init = true
		is_pressed = false
		back_to_title()
		return
	
	if first_grab:
		$GrabText.show()


func _on_Rumia_ate():
	if (first_throw):
		throw_sign.hide()
		first_throw = false
	
	hunger_progress.hunger += 18
	food.isEating = true
	
	if hunger_progress.hunger <= 100:
		food.rumia_go_down()


func _on_Meat_Destroyed():
	var timer = Timer.new()
	timer.autostart = true
	timer.one_shot = true
	timer.wait_time = 0.5
	timer.connect("timeout", self, "_on_spawndelaytimer_timeout")
	call_deferred("add_child", timer)
	
	my_timer.append(timer)


func _on_spawndelaytimer_timeout():
	food.spawn_meat(Vector2(food_box.global_position.x, - 20))


func _on_Meat_Grabbed(isCooked):
	if first_grab:
		$GrabText.hide()
		$CookText.show()
		first_grab = false
	
	if first_throw and isCooked:
		$CookText.hide()
		throw_sign.show()


func _on_btn_title_pressed():
	if is_pressed:
		return
	
	is_pressed = true
	SoundManager.play_click()
	
	if finish_init:
		back_to_title()
	

func back_to_title():
	$Transition.fade_in()
	yield(get_tree().create_timer(1), "timeout")
	if $Final / btn_title.visible:
		get_tree().change_scene("res://Scenes/Title.tscn")
