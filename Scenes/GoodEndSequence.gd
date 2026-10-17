extends Node

var isActivated = false

func play_happy():
	SoundManager.play_happy()


func _on_HungerBar_win():
	if isActivated:
		return
	
	SoundManager.fade_out_music(4.5)
	
	isActivated = true
	
	$InputBlocker.show()
	$transition.show()
	$transition.global_position = get_parent().get_node("Rumia/Focus").global_position
	get_parent().get_node("Final/btn_title").hide()
	
	$AnimationPlayer.play("good_end")
	get_parent().get_node("Food").drop_everything()
	yield(get_tree().create_timer(3.2), "timeout")
	get_parent().get_node("Rumia").now_happy_end()


func _on_AnimationPlayer_animation_finished(anim_name):
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://Ending/GoodEnd.tscn")
