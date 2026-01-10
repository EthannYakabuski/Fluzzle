extends Node2D

var currentLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentLevel = GameState.getLevelToLoad()
	print("i am inside of the game screen - loading level " + str(currentLevel))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
