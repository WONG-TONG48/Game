extends Node

var level:TileMapLayer
var characters:Node
var levelNum := 1

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
	level = $Level.get_node("Level"+str(levelNum))
	level.enabled=true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in $Level.get_children():
		i.enabled=false
	set_current_level()
	characters=$Characters
	load_level()


func _on_player_die() -> void:
	load_level()
