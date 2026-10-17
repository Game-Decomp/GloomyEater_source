extends StaticBody2D

var total = - 1

func _on_CookArea_body_entered(body):
	body.isCooking = true
	
	total += 1
	
	if total == 0:
		SoundManager.play_sizzle()
	else:
		SoundManager.play_sizzle2()


func _on_CookArea_body_exited(body):
	body.isCooking = false
	
	if total == 0:
		SoundManager.stop_sizzle()
	else:
		SoundManager.stop_sizzle2()
	
	total -= 1
