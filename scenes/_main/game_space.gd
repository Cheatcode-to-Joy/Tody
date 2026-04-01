extends Node2D

class_name GameSpace

@export var level_scenes: Array[PackedScene] = []
var level_instances: Array[BaseLevel] = []
var current_index: int = 0

@export var game_camera: Camera2D

func _ready() -> void:
	for level_scene in level_scenes:
		level_instances.append(level_scene.instantiate())

	enter_first_level()

func enter_first_level() -> void:
	add_child(level_instances[current_index])
	set_active(level_instances[current_index])

func enter_next_level() -> void:
	if level_instances.size() <= current_index + 1: return
	
	call_deferred("switch_to_next_level")

func switch_to_next_level() -> void:
	var connection_position = level_instances[current_index].end_transition.global_position
	current_index += 1
	var new_level = level_instances[current_index]
	add_child(new_level)
	new_level.position = connection_position - new_level.start_transition.position
	set_active(new_level)

	var camera_tween = create_tween()
	camera_tween.tween_property(game_camera, "position", new_level.position, 1.0)
	camera_tween.tween_callback(camera_tween.kill)

func set_active(level: BaseLevel) -> void:
	level.end_transition.player_entered.connect(enter_next_level, CONNECT_ONE_SHOT)
	level.boundary.set_collision_layer_value(1, true)
