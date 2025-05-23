extends Node

var active_hotbar_slot
var hotbar : Array 

func _enter_tree() -> void:
	EventSystem.INV_hotbar_updated.connect(hotbar_updated)
	EventSystem.EQU_hotkey_pressed.connect(hotkey_pressed)

func _ready() -> void:
	EventSystem.EQU_active_hotbar_slot_updated.emit(null)

func hotbar_updated(_hotbar : Array) -> void:
	hotbar = _hotbar

func hotkey_pressed(hotkey : int) -> void:
	var idx := hotkey - 1
	
	if hotbar[idx] == null:
		return
	
	if idx != active_hotbar_slot:
		active_hotbar_slot = idx 
		EventSystem.EQU_equip_item.emit(hotbar[idx])
		EventSystem.EQU_active_hotbar_slot_updated.emit(idx)
	
	else:
		active_hotbar_slot = null
		EventSystem.EQU_unequip_item.emit()
		EventSystem.EQU_active_hotbar_slot_updated.emit(null)
