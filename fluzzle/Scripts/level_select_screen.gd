extends Node2D

@export var levelSelectButton: PackedScene

@onready var googleSignInClient: PlayGamesSignInClient = $PlayGamesSignInClient
@onready var onInitializationCompleteListener = OnInitializationCompleteListener.new()

var game_scene = preload("res://Scenes/game_screen.tscn")

#Admob configuration
var adView: AdView

func _enter_tree() -> void: 
	GodotPlayGameServices.initialize()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	androidAuthentication()
	admobConfiguration()
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
