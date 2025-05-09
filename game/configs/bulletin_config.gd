class_name BulletinConfig

enum Keys {
	InteractionPrompt,
	CraftingMenu
}

const BULLETIN_PATHS := {
	Keys.InteractionPrompt : "res://bulletins/interaction_prompt.tscn",
	Keys.CraftingMenu : "res://bulletins/player_menus/crafting_menu.tscn"
}

static func get_bulletin(bulletin_key : Keys) -> Bulletin:
	var scene := load(BULLETIN_PATHS.get(bulletin_key))
	if scene is PackedScene:
		return scene.instantiate() as Bulletin
	else:
		push_error("Invalid scene resource for key: %s" % str(bulletin_key))
		return null
