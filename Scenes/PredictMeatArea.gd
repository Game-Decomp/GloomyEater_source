extends Area2D

var foods = []

onready var rumia = get_parent().get_node("Rumia")
onready var target_pos = $TargetPosition

var catchFoodTween = Tween.new()
var eatFoodTween = Tween.new()

func _ready():
	add_child(catchFoodTween)
	add_child(eatFoodTween)


func _on_PredictMeatArea_area_entered(area):
	var food = area.get_parent()
	foods.append(food)
	food.connect("dropped", self, "_on_Food_dropped")


func _on_PredictMeatArea_area_exited(area):
	var food = area.get_parent()
	foods.erase(food)
	food.disconnect("dropped", self, "_on_Food_dropped")


func _on_Food_dropped(food):
	if not food.isCooked:
		return
	
	var desired_vel: Vector2
	var h = target_pos.global_position.y - food.global_position.y
	desired_vel.y = h - food.gravity * 0.5
	desired_vel.x = target_pos.global_position.x - food.global_position.x
	
	if desired_vel.x < 200:
		desired_vel.x *= 2
		desired_vel.y *= 0.5
	
	if desired_vel.normalized().dot(food.velocity.normalized()) < 0.9:
		return
	if desired_vel.length() - food.velocity.length() > 100:
		return
	
	food.velocity = desired_vel
	
	var target_position = rumia.global_position + Vector2(0, - 200)
	
	if target_position.y < 321:
		target_position.y = 321
	
	catchFoodTween.interpolate_property(
		rumia, "position", 
		rumia.global_position, 
		target_position, 
		0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	catchFoodTween.start()


func _on_Rumia_ate():
	var target_position = rumia.global_position + Vector2(0, 200)
	
	if target_position.y > 480:
		target_position.y = 480
	
	eatFoodTween.interpolate_property(
		rumia, "position", 
		rumia.global_position, 
		target_position, 
		3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	eatFoodTween.start()
