extends Node


const INVENTORY_SIZE = 28

var inventory : Array = []

func _enter_tree() -> void:
	EventSystem.INV_try_to_pickup_item.connect(try_to_pickup_item)
	EventSystem.INV_ask_update_inventory.connect(send_inventory)

# So this line it creates now 28 elements in the inventory and
# the elements value will be null
func _ready() -> void:
	inventory.resize(INVENTORY_SIZE)

func send_inventory() -> void:
	EventSystem.INV_inventory_updated.emit(inventory)

func try_to_pickup_item(item_key : ItemConfig.Keys, destroy_pickuppable : Callable) -> void:
	if not get_free_slots():
		return
	
	add_item(item_key)
	destroy_pickuppable.call()


func get_free_slots() -> int:
	return inventory.count(null)


func add_item(item_key : ItemConfig.Keys) -> void:
	for i in inventory.size():
		if inventory[i] == null:
			inventory[i] = item_key
			break
	
	print(inventory)
