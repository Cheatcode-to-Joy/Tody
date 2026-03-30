extends Node2D

const DEFAULT_SCROLL_SPEED = 25.0
var screen_height = 540

@export var movable_space: Node2D
var scroll_tween: Tween = null

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
		if scroll_tween: scroll_tween.kill()
		return

func initiate_scroll(speed: float) -> void:
	if lock_enabled: return

	movable_space.position.y = fmod(movable_space.position.y + speed, screen_height) ## FIXME: edit this
	if movable_space.position.y > 0: movable_space.position.y -= screen_height ## this wraps to top

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