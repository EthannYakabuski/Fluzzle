extends TextureButton

var level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LevelLabel.text = level

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setLevel(levelToSet) -> void: 
	level = levelToSet

func _on_pressed() -> void:
	print("level button pressed")
	print("loading level: " + level)
