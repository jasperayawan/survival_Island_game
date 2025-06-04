extends CharacterBody3D

const ANIM_BlEND := 0.2

enum States {
	Idle,
	Wander,
	Dead,
	Flee,
	Hurt,
	Chase,
	Attack
}

var state := States.Idle 

@onready var idle_timer: Timer = %IdleTimer
@onready var wander_timer: Timer = %WanderTimer
@onready var disappear_after_death_timer: Timer = %DisappearAfterDeathTimer
@onready var flee_timer: Timer = $Timers/FleeTimer
@onready var player:CharacterBody3D = get_tree().get_first_node_in_group("Player")

@onready var main_collision_shape: CollisionShape3D = $CollisionShape3D
@onready var meat_spawn_marker: Marker3D = $MeatSpawnMarker
@onready var eyes_marker: Marker3D = $EyesMarker
@onready var attack_hit_area: Area3D = $AttackHitArea
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var vision_area_collision_shape: CollisionShape3D = $VisionArea/CollisionShape3D

@export var normal_speed := 0.6
@export var alarmed_speed := 1.8
@export var max_health := 80.0
@export var idle_animations:Array[String] = []
@export var hurt_animations:Array[String] = []
@export var turn_speed_weight := 0.07
@export var min_idle_time := 2.0
@export var max_idle_time := 7.0
@export var min_wander_time := 2.0
@export var max_wander_time := 4.0
@export var flee_time := 3.0
@export var is_aggressive := false
@export var attack_distance := 2.0
@export var damage := 20.0
@export var vision_range := 15.0
@export var vision_fov := 80.0

var player_in_vision_range := false
var health := max_health

func _ready() -> void:
	animation_player.animation_finished.connect(animation_finished)
	vision_area_collision_shape.shape.radius = vision_range

func animation_finished(_anim_name:String) -> void:
	if state == States.Idle:
		animation_player.play(idle_animations.pick_random(), ANIM_BlEND)
	
	elif state == States.Hurt:
		if not is_aggressive:
			set_state(States.Flee)
		
		else:
			set_state(States.Chase)
			
	if state == States.Attack:
		set_state(States.Chase)

func _physics_process(_delta: float) -> void:
	if state == States.Idle:
		idle_loop()
	
	elif state == States.Wander:
		wander_loop()
	elif state == States.Flee:
		flee_loop()
	elif state == States.Chase:
		chase_loop()
	elif state == States.Attack:
		attack_loop()

func idle_loop() -> void:
	if is_aggressive and can_see_player():
		set_state(States.Chase)

func wander_loop() -> void:
	look_forward()
	move_and_slide()
	
	if is_aggressive and can_see_player():
		set_state(States.Chase)

func player_in_pov() -> bool:
	if not player:
		return false
	
	var direction_to_player = global_position.direction_to(player.global_position)
	var forward := -global_transform.basis.z # minus is a forward in Godot
	return direction_to_player.angle_to(forward) <= deg_to_rad(vision_fov)
	

func can_see_player() -> bool:
	return player_in_vision_range and player_in_pov() and player_in_los()

func player_in_los() -> bool:
	if not player:
		return false
	
	var query_params := PhysicsRayQueryParameters3D.new()
	query_params.from = eyes_marker.global_position
	query_params.to = player.global_position + Vector3(0, 1.5, 0)
	query_params.collision_mask = 1 # environment
	var space_state := get_world_3d().direct_space_state
	var result := space_state.intersect_ray(query_params)
	
	return result.is_empty()

func flee_loop() -> void:
	look_forward()
	move_and_slide()

func chase_loop() -> void:
	look_forward()
	if global_position.distance_to(player.global_position) < attack_distance:
		set_state(States.Attack)
		return
		
	nav_agent.target_position = player.global_position
	var dir := global_position.direction_to(nav_agent.get_next_path_position())
	dir.y = 0
	velocity = dir.normalized() * alarmed_speed
	move_and_slide()

func attack_loop() -> void:
	var dir = global_position.direction_to(player.global_position)
	rotation.y = lerp_angle(rotation.y, atan2(dir.x, dir.z) * PI, turn_speed_weight)

func attack() -> void:
	if player in attack_hit_area.get_overlapping_bodies():
		EventSystem.PLA_change_health.emit(-damage)

func look_forward() -> void:
	rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z) + PI, turn_speed_weight)

func pick_wander_velocity() -> void:
	var dir := Vector2(0, -1).rotated(randf() * PI * 2)
	velocity = Vector3(dir.x, 0, dir.y) * normal_speed


func _on_idle_timer_timeout() -> void:
	set_state(States.Wander)


func _on_wander_timer_timeout() -> void:
	set_state(States.Idle)


func _on_disappear_after_death_timer_timeout() -> void:
	queue_free()

func _on_flee_timer_timeout() -> void:
	set_state(States.Idle)

func pick_away_from_player_velocity() -> void:
	if not player:
		set_state(States.Idle)
		return
	
	var dir := player.global_position.direction_to(global_position)
	dir.y = 0
	velocity = dir.normalized() * alarmed_speed

func set_state(new_state : States) -> void:
	state = new_state
	
	match state:
		States.Idle:
			idle_timer.start(randf_range(min_idle_time, max_idle_time))
			animation_player.play(idle_animations.pick_random(), ANIM_BlEND)
		
		States.Wander:
			pick_wander_velocity()
			wander_timer.start(randf_range(min_wander_time, max_wander_time))
			animation_player.play("Walk", ANIM_BlEND)
		
		States.Hurt:
			idle_timer.stop()
			wander_timer.stop()
			flee_timer.stop()
			animation_player.play(hurt_animations.pick_random(), ANIM_BlEND)
		
		States.Flee:
			pick_away_from_player_velocity()
			animation_player.play("Gallop", ANIM_BlEND)
			flee_timer.start(flee_time)
		
		States.Chase:
			idle_timer.stop()
			wander_timer.stop()
			flee_timer.stop()
			animation_player.play("Gallop", ANIM_BlEND)
		
		States.Attack:
			animation_player.play("Attack", ANIM_BlEND)
		
		States.Dead:
			animation_player.play("Death", ANIM_BlEND)
			main_collision_shape.disabled = true
			var meat_scene := ItemConfig.get_pickuppable_item(ItemConfig.Keys.RawMeat)
			EventSystem.SPA_spawn_scene.emit(meat_scene, meat_spawn_marker.global_transform)
			idle_timer.stop()
			wander_timer.stop()
			flee_timer.stop()
			set_physics_process(false)
			disappear_after_death_timer.start(10)


func take_hit(weapon_item_resource : WeaponItemResource) -> void:
	health -= weapon_item_resource.damage
	
	if state != States.Dead and health <= 0:
		set_state(States.Dead)
	
	elif not state in [States.Flee, States.Dead]:
		set_state(States.Hurt)


func _on_vision_area_body_entered(body: Node3D) -> void:
	if body == player:
		player_in_vision_range = true


func _on_vision_area_body_exited(body: Node3D) -> void:
	if body == player:
		player_in_vision_range = false
