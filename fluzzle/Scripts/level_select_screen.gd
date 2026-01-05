extends Node2D

@export var levelSelectButton: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populateLevelScreen()
	
#populate all of the level tiles on the game screen
func populateLevelScreen() -> void: 
	
	for i in range(3): 
		var levelButtonToAdd = levelSelectButton.instantiate()
		levelButtonToAdd.setLevel(str(i+1))
		levelButtonToAdd.position.x = levelButtonToAdd.position.x + 400*i
		add_child(levelButtonToAdd)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
