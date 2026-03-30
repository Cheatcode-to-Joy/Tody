extends Node2D

const ROW_LENGTH = 15

const TILE_HEIGHT = 16.0
const DEFAULT_SCROLL_SPEED = 16.0
var screen_height = 540

@export var movable_space: Node2D
@export var foreground_map: TileMapLayer

@export var lock_animator: AnimationPlayer
var lock_enabled: bool = false

func toggle_lock(new_enabled: bool) -> void:
	if (lock_enabled && !new_enabled):
		lock_enabled = false
		lock_animator.play("unlock")
		return
	if (!lock_enabled && new_enabled):
		lock_enabled = true
		lock_animator.play("lock")
		return

func initiate_scroll(speed: float) -> void:
	if lock_enabled: return

	movable_space.position.y = movable_space.position.y + speed

	var global_tile_offset = movable_space.position.y / TILE_HEIGHT
	var upper_row = -1 - global_tile_offset
	var lower_row = 34 - global_tile_offset
	move_tiles(upper_row if speed < 0 else lower_row, lower_row if speed < 0 else upper_row)

	## if movable_space.position.y > 0: movable_space.position.y -= screen_height ## this wraps to top

func move_tiles(old_row: int, new_row: int) -> void:
	for index in range(ROW_LENGTH):
		var old_coords = Vector2i(index, old_row)
		var atlas_coords = foreground_map.get_cell_atlas_coords(old_coords)
		var alt_tile = foreground_map.get_cell_alternative_tile(old_coords)

		var new_coords = Vector2i(index, new_row)
		foreground_map.set_cell(new_coords, 0, atlas_coords, alt_tile)

func _on_slice_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_released("scroll_up"):
		initiate_scroll(DEFAULT_SCROLL_SPEED)
		return
	if event.is_action_released("scroll_down"):
		initiate_scroll(-DEFAULT_SCROLL_SPEED)
		return

func _on_slice_area_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")): toggle_lock(true)

func _on_slice_area_body_exited(body: Node2D) -> void:
	if (body.is_in_group("player")): toggle_lock(false)