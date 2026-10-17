extends KinematicBody2D

signal grabbed
signal dropped
signal destroyed

var isMouseEntered = false
var isDrag = false

var isCooking = false setget setIsCooking
var isCooked = false setget setIsCooked
var cookTimer = 0

var meat_image = preload("res://FeedRumiaConcept/Meat.PNG")
var cooked_meat_image = preload("res://FeedRumiaConcept/MeatCooked.PNG")

var last_is_on_floor = false

export (float) var mouse_strength = 700
export (float) var max_mouse_distance = 100
export (float) var gravity = 2280
export (float) var friction = 0.5
var velocity: Vector2

func _process(delta):
	if Input.is_action_just_pressed("mouse_left") and isMouseEntered:
		var others = get_tree().get_nodes_in_group("meat")
		for m in others:
			m.isDrag = false
		
		isDrag = true
		emit_signal("grabbed", isCooked)
	
	if isDrag:
		var mouse_distance = get_global_mouse_position() - global_position
		velocity = mouse_distance.clamped(max_mouse_distance) * mouse_strength * delta
	
	if isDrag and Input.is_action_just_released("mouse_left"):
		isDrag = false
		emit_signal("dropped", self)
	
	
	if isCooking:
		cookTimer += delta
		if cookTimer > 3 and not isCooked:
			self.isCooked = true
			self.isCooking = isCooking
		if cookTimer > 10 and isCooked:
			set_process(false)
			$Particles2D.emitting = false
			$Particles2D_short.emitting = false
			$Particles2D_burnt.emitting = true
			$Sprite.modulate = Color(0.1, 0.1, 0.1)
			$BurntTimer1.start()

func _on_BurntTimer1_timeout():
	$Sprite.hide()
	$Particles2D_burnt.emitting = false
	set_physics_process(false)
	set_deferred("collission_layer", 0)
	global_position += Vector2(0, 50)
	$BurntTimer2.start()


func _on_BurntTimer2_timeout():
	queue_free()


func _physics_process(delta):
	velocity += Vector2.DOWN * gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		velocity = lerp(velocity, Vector2.ZERO, friction)
	
		if is_on_floor() != last_is_on_floor:
			SoundManager.play_drop()
	
	last_is_on_floor = is_on_floor()


func _on_MouseDetector_mouse_entered():
	isMouseEntered = true


func _on_MouseDetector_mouse_exited():
	isMouseEntered = false


func _on_VisibilityNotifier2D_screen_exited():
	emit_signal("destroyed")
	queue_free()


func setIsCooked(val):
	isCooked = val
	
	if isCooked:
		$Sprite.texture = cooked_meat_image
	else:
		$Sprite.texture = meat_image


func setIsCooking(val):
	isCooking = val
	
	$Particles2D.emitting = val and not isCooked
	$Particles2D_short.emitting = val and isCooked
