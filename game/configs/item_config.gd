class_name ItemConfig

enum Keys {
	# pickuppables
	Stick,
	Stone,
	Plant,
	Mushroom,
	Fruit,
	Log,
	Coal,
	Flintstone,
	RawMeat,
	CookedMeat,
	
	# craftables
	Axe,
	Pickaxe,
	Campfire,
	Multitool,
	Rope,
	Tinderbox,
	Torch,
	Tent,
	Raft
}


const CRAFTABLE_ITEM_KEYS : Array[Keys] = [
	Keys.Axe,
	#Keys.Pickaxe,
	#Keys.Campfire,
	#Keys.Multitool,
	Keys.Rope,
	#Keys.Tinderbox,
	#Keys.Torch,
	#Keys.Tent,
	#Keys.Raft
]

const ITEM_RESOURCE_PATHS := {
	Keys.Stick : "res://resources/item_resources/stick_resource.tres",
	Keys.Stone : "res://resources/item_resources/stone_resource.tres",
	Keys.Plant : "res://resources/item_resources/plant_resource.tres",
	Keys.Axe : "res://resources/item_resources/axe_item_resource.tres",
	Keys.Pickaxe : "res://resources/item_resources/pickaxe_item_resource.tres",
	Keys.Rope : "res://resources/item_resources/rope_resource.tres",
	Keys.Log : "res://resources/item_resources/log_resource.tres",
	Keys.Mushroom : "res://resources/item_resources/mushroom_item_resource.tres",
	Keys.Coal : "res://resources/item_resources/coal_resource.tres",
	Keys.Flintstone : "res://resources/item_resources/flinstone_resource.tres",
	Keys.RawMeat : "res://resources/item_resources/raw_meat_item_resource.tres"
}

static func get_item_resource(key : Keys) -> ItemResource:
	return load(ITEM_RESOURCE_PATHS.get(key))


const CRAFTING_BLUEPRINT_RESOURCE_PATHS := {
	Keys.Axe : "res://resources/crafting_blueprint_resources/axe_blueprint.tres",
	Keys.Pickaxe : "res://resources/crafting_blueprint_resources/pickaxe_blueprint.tres",
	Keys.Rope : "res://resources/crafting_blueprint_resources/rope_blueprint.tres",
}

static func get_crafting_blueprint_resource(key : Keys) -> CraftingBlueprintResource:
	return load(CRAFTING_BLUEPRINT_RESOURCE_PATHS.get(key))

const EQUIPPABLE_ITEM_PATHS := {
	Keys.Axe : "res://items/equippables/equippable_axe.tscn",
	Keys.Pickaxe : "res://items/equippables/equippable_pickaxe.tscn",
	Keys.Mushroom : "res://items/equippables/equippable_mushroom.tscn"
}

static func get_equipple_item(key : Keys) -> PackedScene:
	return load(EQUIPPABLE_ITEM_PATHS.get(key))

const PICKUPPABLE_ITEM_PATHS := {
	Keys.Log : "res://items/interactables/rigid_pickuppable_log.tscn",
	Keys.Coal : "res://items/interactables/rigid_pickuppable_coal.tscn",
	Keys.Flintstone : "res://items/interactables/rigid_pickuppable_flinstone.tscn",
	Keys.RawMeat : "res://items/interactables/rigid_pickuppable_raw_meat.tscn",
}

static func get_pickuppable_item(key : Keys) -> PackedScene:
	return load(PICKUPPABLE_ITEM_PATHS.get(key))
