extends CanvasLayer

@onready var player = $"../Player"
@onready var stage_1 = $".."
@onready var blackscreen = $Blackscreen

func _ready():
	blackscreen.hide()

func death_scene():
	stage_1.hideOtherElementsExceptPlayer()
	blackscreen.show()
