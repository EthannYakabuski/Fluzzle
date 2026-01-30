extends Node2D

@onready var snapshotClient: PlayGamesSnapshotsClient = $PlayGamesSnapshotsClient
var currentData = ""
var hasData = false

signal dataLoaded

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	snapshotClient.game_loaded.connect(gameDataReady)

func setData(data): 
	hasData = true
	currentData = data
	
func getData(): 
	return currentData
	
func loadData():
	snapshotClient.load_game("FluzzleData", true)
	
func saveData(): 
	var dataToSave = JSON.stringify(currentData)
	snapshotClient.save_game("FluzzleData", "Player data for the app Fluzzle", dataToSave.to_utf8_buffer())
	
func gameDataReady(): 
	emit_signal("dataLoaded")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
