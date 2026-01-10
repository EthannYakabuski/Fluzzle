extends Node

var levelToLoad = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func setLevelToLoad(level) -> void: 
	print("inside of game state -> setting level to " + str(level))
	levelToLoad = level
	
func getLevelToLoad() -> String: 
	return levelToLoad
