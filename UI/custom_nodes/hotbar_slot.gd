extends InventorySlot
class_name HotbarSlot

const ACTIVE_COLOR = Color.WHITE 
const UNACTIVE_COLOR = Color(0.8, 0.8, 0.8, 0.6)

func _ready() -> void:
	$NumTextureRect/NumLabel.text = str(get_index() + 1)


func _can_drop_data(at_position: Vector2, origin_slot: Variant) -> bool:
	if not origin_slot is InventorySlot:
		return false
	 
	return ItemConfig.get_item_resource(origin_slot.item_key).is_quippable

func set_highlighted(enabled : bool) -> void:
	modulate = UNACTIVE_COLOR if not enabled else ACTIVE_COLOR
