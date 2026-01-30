extends Node2D

@export var levelSelectButton: PackedScene

@onready var googleSignInClient: PlayGamesSignInClient = $PlayGamesSignInClient
@onready var onInitializationCompleteListener = OnInitializationCompleteListener.new()

var game_scene = preload("res://Scenes/game_screen.tscn")

signal dataHasLoaded
#Admob configuration
var adView: AdView

func _enter_tree() -> void: 
	GodotPlayGameServices.initialize()
	dataHasLoaded.connect(dataLoaded)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	androidAuthentication()
	admobConfiguration()
	
func dataLoaded(): 
	print("data has been loaded")
	populateLevelScreen()
	
func androidAuthentication() -> void: 
	if not GodotPlayGameServices.android_plugin: 
		printerr("Plugin not found")
		if not PlayerData.hasData:
			var dummyData = { 
				"LevelsCompleted": [1]
			}
			var jsonStringDummyData = JSON.stringify(dummyData)
			var jsonParsed = JSON.parse_string(jsonStringDummyData)
			PlayerData.setData(jsonParsed)
		emit_signal("dataHasLoaded")
	else: 
		print("Plugin has found")
		googleSignInClient.is_authenticated()
	
#populate all of the level tiles on the game screen
func populateLevelScreen() -> void: 
	print("inside populate level screen")
	var currentData = PlayerData.getData()
	var levelsCompleted = currentData["LevelsCompleted"].map(func(v): return int(v))
	print(levelsCompleted)
	for i in range(3):
		var isLevelCompleted = false
		if i+1 in levelsCompleted: 
			isLevelCompleted = true
			print("level " + str(i+1) + " has already been completed")
		var levelButtonToAdd = levelSelectButton.instantiate()
		levelButtonToAdd.levelSelected.connect(levelHasBeenSelected)
		levelButtonToAdd.setLevel(str(i+1))
		levelButtonToAdd.position.x = levelButtonToAdd.position.x + 400*i
		if isLevelCompleted: 
			levelButtonToAdd.modulate = Color(0.292, 0.794, 0.335, 1.0)
		add_child(levelButtonToAdd)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func onGameLoaded(snapshot: PlayGamesSnapshot): 
	print("game data has been loaded")
	if snapshot.content.size() == 0 or snapshot.content.is_empty(): 
		var currentData = { 
			"LevelsCompleted": []
		}
		PlayerData.setData(currentData)
		PlayerData.saveData()
		dataLoaded()
	else: 
		var dataToLoad = snapshot.content.get_string_from_utf8()
		var jsonData = JSON.parse_string(dataToLoad)
		PlayerData.setData(jsonData)
		dataLoaded()

func levelHasBeenSelected() -> void: 
	print("level has been selected -> going to load the game screen")
	get_tree().change_scene_to_packed(game_scene)

func admobConfiguration() -> void: 
	print("inside admob configuration")
	onInitializationCompleteListener.on_initialization_complete = onAdInitilizationComplete
	var requestConfig = RequestConfiguration.new()
	#child friendly ads
	requestConfig.tag_for_child_directed_treatment = RequestConfiguration.TagForChildDirectedTreatment.TRUE
	#child friendly rating
	requestConfig.max_ad_content_rating = RequestConfiguration.MAX_AD_CONTENT_RATING_G
	
	if MobileAds: 
		print("mobile ads is found")
		MobileAds.initialize(onInitializationCompleteListener)
		MobileAds.set_request_configuration(requestConfig)
	else: 
		print("mobile ads plugin not found")

func onAdInitilizationComplete(status: InitializationStatus) -> void:
	print("banner ad init complete") 
	createBannerAd()
	
func createBannerAd() -> void: 
	if adView: 
		destroyAdView()
		
	var adListener = AdListener.new()
	adListener.on_ad_failed_to_load = func(load_ad_error: LoadAdError): 
		print("banner ad failed to load")
	adListener.on_ad_loaded = func(): 
		print("banner ad loaded")
		adView.show()
	
	var unit_id = "ca-app-pub-3940256099942544/6300978111"
	adView = AdView.new(unit_id, AdSize.BANNER, AdPosition.Values.BOTTOM_LEFT)
	adView.ad_listener = adListener
	var ad_request = AdRequest.new()
	adView.load_ad(ad_request)
		
func destroyAdView() -> void: 
	if adView: 
		adView.destroy()
		adView = null

func _on_achievement_button_pressed() -> void:
	$PlayGamesAchievementsClient.show_achievements()


func _on_leaderboard_button_pressed() -> void:
	$PlayGamesLeaderboardsClient.show_all_leaderboards()

func _on_play_games_sign_in_client_user_authenticated(is_authenticated: bool) -> void:
	print("is_authenticated callback")
	PlayerData.dataLoaded.connect(dataLoaded)
	PlayerData.snapshotClient.game_saved.connect(
		func(is_saved: bool, savedDataName: String, savedDataDescription: String): 
			print("data saved")
	)
	PlayerData.snapshotClient.game_loaded.connect(onGameLoaded)
	if is_authenticated: 
		PlayerData.loadData()
