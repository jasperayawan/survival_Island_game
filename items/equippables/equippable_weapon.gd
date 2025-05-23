extends EquippableItem
class_name EquippableWeapon

@onready var hit_check_marker: Marker3D = $HitCheckMarker


var weapon_item_resource : WeaponItemResource


func _ready() -> void:
	hit_check_marker.position.z = -weapon_item_resource.range
	super()

func change_energy()-> void:
	EventSystem.PLA_change_energy.emit(weapon_item_resource.enery_change_pre_use)

func check_hit() -> void:
	var space_state := get_world_3d().direct_space_state
	var ray_query_params := PhysicsRayQueryParameters3D.new() 
	ray_query_params.collide_with_areas = true 
	ray_query_params.collide_with_bodies = false
	ray_query_params.collision_mask = 8 # hitbox
	ray_query_params.from = global_position
	ray_query_params.to = hit_check_marker.global_position
	print("Ray From:", ray_query_params.from)
	print("Ray To:", ray_query_params.to)
	
	var result := space_state.intersect_ray(ray_query_params)
	print(result)
	if not result.is_empty():
		result.collider.take_hit(weapon_item_resource)
