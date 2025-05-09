extends Bulletin

@onready var inventory_container: GridContainer = %InventoryContainer

func _enter_tree() -> void:
	EventSystem.INV_inventory_updated.connect(update_envintory_slot)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventSystem.PLA_freeze_player.emit()
	EventSystem.UI_hide_HUD.emit()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	EventSystem.INV_ask_update_inventory.emit()

func close() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.CraftingMenu)
	EventSystem.PLA_unfreeze_player.emit()
	EventSystem.UI_unhide_HUD.emit()

func update_envintory_slot(inventory : Array) -> void:
	for i in inventory.size():
		inventory_container.get_child(i).set_item_key(inventory[i])
