extends Node

var level:TileMapLayer
var characters:Node

func load_level() -> void:
	for i:CharacterBody2D in characters.get_children():
		i.reset()
	for i:Marker2D in level.get_children():
		if i.name.match("*Pos"):
			var object = characters.find_child(i.name.left(-3))
			object.position = i.position
			object.enabled=true
			object.visible=true

	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level =$Level1
	characters=$Characters
	load_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_die() -> void:
	load_level()
