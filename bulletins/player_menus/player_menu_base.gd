extends Bulletin


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventSystem.PLA_freeze_player.emit()
	EventSystem.UI_hide_HUD.emit()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func close() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.CraftingMenu)
	EventSystem.PLA_unfreeze_player.emit()
	EventSystem.UI_unhide_HUD.emit()
