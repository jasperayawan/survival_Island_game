extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventSystem.UI_unhide_HUD.connect(unhide_hud)
	EventSystem.UI_hide_HUD.connect(hide_hud)

func unhide_hud() -> void:
	$".".visible = true

func hide_hud() -> void:
	$".".visible = false
