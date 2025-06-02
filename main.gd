extends Node

var level:TileMapLayer
var characters:Node
var levelNum := 1
var maxLevel:int
var camera:Camera2D
var died :=false

func load_level() -> void:
	for i:CharacterBody2D in characters.get_children():
		i.disable()
	for i:Marker2D in level.get_children():
		if i.name.match("*Pos"):
			var object = characters.get_node(i.name.left(-3))
			object.position = i.position
			object.enable()

func set_current_level() -> void:
	if level != null:
		level.enabled=false
		level.visible=false
	maxLevel=$Level.get_child_count()
	level = $Level.get_node("Level"+str(levelNum))
	camera=$Characters/Player/Camera2D
	level.enabled=true
	level.visible=true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in $Level.get_children():
		i.enabled=false
		i.visible=false
	set_current_level()
	characters=$Characters
	load_level()

func _on_player_die() -> void:
	$AnimationPlayer.play("Clear")
	$DeathTimer.start()


func _on_player_level_cleared() -> void:
	if levelNum != maxLevel:
		$ClearTimer.start()
		$AnimationPlayer.play("Clear")
		
		


func _on_death_timer_timeout() -> void:
	load_level()
	


func _on_clear_timer_timeout() -> void:
	levelNum+=1
	set_current_level()
	load_level()
