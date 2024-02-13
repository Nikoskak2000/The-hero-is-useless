extends CharacterBody2D

signal healthChanged

@export var movement_data : PlayerMovementData

#double jump var air_jump = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyotejump_timer = $CoyotejumpTimer
@onready var currenthealth: int = movement_data.maxHealth
@onready var canvas_layer_2 = $/root/World/CanvasLayer2

var movement = true
var dead = false
var invis_frames = false

func _physics_process(delta):
	if movement:
		apply_gravity(delta)
	
	#double jump if is_on_floor(): air_jump = true 
	
		if is_on_floor() or coyotejump_timer.time_left > 0.0:
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = movement_data.JUMP_VELOCITY
		if not is_on_floor():
			if Input.is_action_just_released("jump") and velocity.y < movement_data.JUMP_VELOCITY / 2:
				velocity.y = movement_data.JUMP_VELOCITY / 2
		#double jump	if Input.is_action_just_pressed("ui_accept") and air_jump:
				#velocity.y = movement_data.JUMP_VELOCITY
				#air_jump = false
		wall_jump()
		var direction = Input.get_axis("left", "right")
		if direction != 0:
			velocity.x = move_toward(velocity.x, movement_data.SPEED * direction, movement_data.ACCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, movement_data.FRICTION * delta)
	
		update_animations(direction)
		var was_on_floor = is_on_floor()
		move_and_slide()
		var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
		if just_left_ledge:
			coyotejump_timer.start()
		

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func wall_jump():
	if not is_on_wall(): return
	var wall_normal = get_wall_normal()
	if Input.is_action_just_pressed("left") and wall_normal == Vector2.LEFT:
		velocity.x = wall_normal.x * movement_data.SPEED
		velocity.y = movement_data.JUMP_VELOCITY
	if Input.is_action_just_pressed("right") and wall_normal == Vector2.RIGHT:
		velocity.x = wall_normal.x * movement_data.SPEED
		velocity.y = movement_data.JUMP_VELOCITY
		

func update_animations(direction):
	if currenthealth <= 0:
		animated_sprite_2d.play("Death")
	else:
		if direction != 0:
			#animated_sprite_2d.flip_h = direction < 0
			animated_sprite_2d.play("run")
		else: 
			animated_sprite_2d.play("idle")
		if  not is_on_floor():
			animated_sprite_2d.play("jump")
	
	
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	if movement:
		if mouse_pos.x < global_position.x:
			$AnimatedSprite2D.scale.x = -0.363
			$Gun.scale.y = -0.346
		else:
			$AnimatedSprite2D.scale.x = 0.363
			$Gun.scale.y = 0.346

func _on_hazard_detector_area_entered(area):
	#if not invis_frames:
		currenthealth -= 1
		healthChanged.emit(currenthealth)
		if currenthealth <= 0:
			movement = false
			canvas_layer_2.death_scene()
			var gun = $Gun
			if gun:
				gun.queue_free()
			update_animations(1)
			await get_tree().create_timer(3).timeout
			queue_free()
			
		print(currenthealth)
		#invis_frames = true
		#await get_tree().create_timer(1).timeout
		#invis_frames = false
