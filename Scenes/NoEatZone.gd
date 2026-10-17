extends Area2D

func _on_NoEatZone_area_entered(area):
	area.set_deferred("monitoring", false)


func _on_NoEatZone_area_exited(area):
	area.set_deferred("monitoring", true)
