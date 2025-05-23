extends Camera3D


@onready var eqiuppable_item_camera: Camera3D = %EqiuppableItemCamera


func _process(_delta: float) -> void:
	eqiuppable_item_camera.global_transform = global_transform
