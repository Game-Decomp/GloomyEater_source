extends Node2D

onready var rumia = get_parent().get_node("Rumia")
onready var hunger_progress = get_parent().get_node("HungerBar")

var catchFoodTween = Tween.new()
var eatFoodTween = Tween.new()

var isEating = false

const meat_scene = preload("res://Scenes/Meat.tscn")

func _ready():
	add_child(catchFoodTween)
	add_child(eatFoodTween)


func drop_everything():
	for m in get_tree().get_nodes_in_group("meat"):
		m.isMouseEntered = false
		m.isDrag = false


func spawn_meat(pos):
	var food = meat_scene.instance()
	food.global_position = pos
	
	food.connect("grabbed", get_parent(), "_on_Meat_Grabbed")
	food.connect("destroyed", get_parent(), "_on_Meat_Destroyed")
	
	food.connect("dropped", self, "_on_Food_dropped")
	
	call_deferred("add_child", food)


func _on_Food_dropped(food):
	if not food.isCooked or isEating or rumia.mouth.frame == 3:
		return
	
	var target_position = rumia.global_position
	var t = 0.5
	
	var delta_x = rumia.global_position.x - food.global_position.x
	
	if abs(delta_x) < 50:
		target_position.y = clamp(food.global_position.y, 321, 480)
	else:
		t = delta_x / food.velocity.x
		
		if t < 0:
			return
		
		var predicted_local_height = food.velocity.y * t + 0.5 * food.gravity * t * t
		var predicted_height = food.global_position.y + predicted_local_height
		
		target_position.y = clamp(predicted_height, 321, 480)
		
		if predicted_height < 321:
			var tan_alpha = food.velocity.y / food.velocity.x
			var delta_y = food.global_position.y - 321
			
			var Vx = sqrt( - food.gravity * delta_x * delta_x / (2 * (delta_x * tan_alpha + delta_y)))
			var Vy = Vx * tan_alpha
			
			var desired_velocity = Vector2(Vx, Vy)
			
			
			food.velocity = sign(delta_x) * desired_velocity
		
		if predicted_height > 450:
			return
	
	eatFoodTween.remove_all()
	if catchFoodTween.is_active():
		catchFoodTween.remove_all()
	
	catchFoodTween.interpolate_property(
		rumia, "position", 
		rumia.global_position, 
		target_position, 
		clamp(t, 0.5, 5), 
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	catchFoodTween.start()
	
	rumia.mouth.frame = 0
	
	$WaitFoodTimer.start(t + 0.5)


func _on_WaitFoodTimer_timeout():
	if not isEating and hunger_progress.hunger_proxy > 0:
		rumia.now_sad()
		rumia_go_down()


func rumia_go_down():
	var target_position = rumia.global_position
	target_position.y = 480
	
	eatFoodTween.remove_all()
	eatFoodTween.interpolate_property(
		rumia, "position", 
		rumia.global_position, 
		target_position, 
		3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	eatFoodTween.start()


func _on_Node2D_pet():
	eatFoodTween.remove_all()


func _on_Node2D_stop():
	if $PatienceTimer.is_stopped():
		$PatienceTimer.start()

func _on_PatienceTimer_timeout():
	if hunger_progress.hunger_proxy > 0 and not eatFoodTween.is_active():
		rumia_go_down()


func _on_Rumia_finish_eat():
	isEating = false
