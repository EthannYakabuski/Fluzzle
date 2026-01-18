extends Node2D

var currentLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentLevel = GameState.getLevelToLoad()
	print("i am inside of the game screen - loading level " + str(currentLevel))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	$PlayGamesAchievementsClient.unlock_achievement("CgkI6rzk5YofEAIQAQ")
	$PlayGamesAchievementsClient.increment_achievement("CgkI6rzk5YofEAIQAg", 1)
	calculatePlayerScore()
	get_tree().change_scene_to_file("res://Scenes/level_select_screen.tscn")
	
func calculatePlayerScore() -> void: 
	$PlayGamesLeaderboardsClient.submit_score("CgkI6rzk5YofEAIQBA", 100)
