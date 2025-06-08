extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -130.0
const MAX_SPEED = 400.0
const JUMP_FRAMES = 6
var direction = 0
var air_time = 0
@export var delay:int
var jumps:Array[Array]
var jump :bool
var move:Array[Array]
var last:float
signal levelCleared
signal die

func disable() -> void:
	move.clear()
	direction=0
	jumps.clear()
	last=0
	jump=false
	velocity=Vector2.ZERO
	visible=false
	set_physics_process(false)
	
func enable() -> void:
	visible=true
	set_physics_process(true)
	if Input.is_action_pressed("jump"):
		jumps.append([Time.get_ticks_msec()+delay*1000,true])
	var val = Input.get_axis("move_left", "move_right")
	if val!=0:
		move.append([Time.get_ticks_msec()+delay*1000,val])

func _ready() -> void:
	disable()

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		air_time+=1
	else:
		air_time=0
	if delay==0:
		jump = Input.is_action_pressed("jump")
	else:
		if len(jumps) and jumps[0][0]<=Time.get_ticks_msec():
			jump=jumps[0][1]
			jumps.remove_at(0)
		if Input.is_action_just_pressed("jump"):
			jumps.append([Time.get_ticks_msec()+delay*1000,true])
		elif Input.is_action_just_released("jump"):
			jumps.append([Time.get_ticks_msec()+delay*1000,false])
	if jump and air_time<JUMP_FRAMES:
		velocity.y += JUMP_VELOCITY
		
	$UpArrow.visible = jump

	var val = Input.get_axis("move_left", "move_right")
	if delay==0:
		direction = val
	else:
		if len(move) and move[0][0]<=Time.get_ticks_msec():
			direction=move[0][1]
			move.remove_at(0)
		if val!=last:
			move.append([Time.get_ticks_msec()+delay*1000,val])
	if direction:
		velocity.x = move_toward(velocity.x, MAX_SPEED * direction, SPEED * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, 1000*delta)
	$RightArrow.visible = direction==1
	$LeftArrow.visible = direction==-1
	last=val
	move_and_slide()

	




func _on_spike_body_entered(body: Node2D) -> void:
	die.emit()

func _on_win_body_entered(body: Node2D) -> void:
	levelCleared.emit()
