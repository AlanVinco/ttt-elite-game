extends Control

@onready var labelTime = $CanvasLayer/TextureRect/LabelTime
@onready var labelMoney = $CanvasLayer/TextureRect2/LabelMoney
@onready var labelKeys = $CanvasLayer/LabelKeys
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	labelTime.text = GlobalTime.TOTAL_TIME
	labelMoney.text = GlobalMoney.PLAYER_MONEY
	labelKeys.text = "Keys: x" + str(GlobalItems.KEYS)
	GlobalItems.BATHROOM_KEY.connect(self._get_bathroom_key)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	GlobalTime.change_time()
	labelTime.text = GlobalTime.TOTAL_TIME

func _get_bathroom_key():
	labelKeys.text = "Keys: x" + str(GlobalItems.KEYS)
