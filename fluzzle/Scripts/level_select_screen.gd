extends Node2D

@export var levelSelectButton: PackedScene

@onready var googleSignInClient: PlayGamesSignInClient = $PlayGamesSignInClient

var game_scene = preload("res://Scenes/game_screen.tscn")

func _enter_tree() -> void: 
	GodotPlayGameServices.initialize()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	androidAuthentication()
	populateLevelScreen()
	
	
func androidAuthentication() -> void: 
	if not GodotPlayGameServices.android_plugin: 
		printerr("Plugin not found")
	else: 
		print("Plugin has found")
		googleSignInClient.is_authenticated()
	
#populate all of the level tiles on the game screen
func populateLevelScreen() -> void: 
	
	for i in range(3): 
		var levelButtonToAdd = levelSelectButton.instantiate()
		levelButtonToAdd.levelSelected.connect(levelHasBeenSelected)
		levelButtonToAdd.setLevel(str(i+1))
		levelButtonToAdd.position.x = levelButtonToAdd.position.x + 400*i
		add_child(levelButtonToAdd)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func levelHasBeenSelected() -> void: 
	print("level has been selected -> going to load the game screen")
	get_tree().change_scene_to_packed(game_scene)
	
	
