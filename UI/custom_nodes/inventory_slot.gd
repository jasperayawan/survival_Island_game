extends TextureRect
class_name InventorySlot

@onready var icon_texture_rect: TextureRect = $MarginContainer/IconTextureRect

var item_key

func set_item_key(_item_key) -> void:
	item_key = _item_key
	update_icon()


func update_icon() -> void:
	if item_key == null:
		icon_texture_rect.texture = null
		return
	
	icon_texture_rect.texture = ItemConfig.get_item_resource(item_key).icon
