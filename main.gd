extends Node

@export var gameScene:PackedScene

func _ready() -> void:
	pass

func _on_main_menu_start() -> void:
	$"Main Menu".visible=false
	get_node(".").add_child(gameScene.instantiate())
