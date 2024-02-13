extends Node2D

@export var movement_data : PlayerMovementData
@onready var heartsContainer = $CanvasLayer/HeartsContainer
@onready var player = $Player
@onready var blackscreen = $CanvasLayer2/Blackscreen
@onready var canvas_layer_2 = $CanvasLayer2

func _ready():
	heartsContainer.setMaxHearts(movement_data.maxHealth)
	heartsContainer.updateHearts(player.currenthealth)
	player.healthChanged.connect(heartsContainer.updateHearts)
	var cursor_texture = preload("res://sprites/hud/mouse cursor.png")
	Input.set_custom_mouse_cursor(cursor_texture, Input.CURSOR_ARROW)

func hideOtherElementsExceptPlayer():
	for child in get_children():
		if child != player and child != canvas_layer_2:
				child.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
