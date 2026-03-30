extends CharacterBody2D

class_name PlayerCharacter

@export var sprite: Sprite2D
@export var tree: PlayerTree
@export var state: PlayerState

const RUN_SPEED = 180.0
const JUMP_STRENGTH = 260.0
const GRAVITY_STRENGTH = 600.0

@export var buffer_timer: Timer
const BUFFER_TIME = 0.3

@export var coyote_timer: Timer
const COYOTE_TIME = 0.3

func _physics_process(delta: float) -> void:
	velocity.x = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * RUN_SPEED
	velocity.y += GRAVITY_STRENGTH * delta

	tree.is_on_floor = is_on_floor()

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		if state.vstate == state.vstates.STAND:
			jump()
		elif coyote_timer.time_left > 0:
			jump()
			coyote_timer.stop()
		else:
			buffer_timer.start(BUFFER_TIME)

func jump() -> void:
	velocity.y -= JUMP_STRENGTH

func _on_state_vstate_changed(old_vstate: PlayerState.vstates, new_vstate: PlayerState.vstates) -> void:
	tree.is_jumping = new_vstate == state.vstates.JUMP
	tree.is_falling = new_vstate == state.vstates.FALL

	if new_vstate == state.vstates.STAND && buffer_timer.time_left > 0:
		jump()
		return
	if old_vstate == state.vstates.STAND && new_vstate == state.vstates.FALL:
		coyote_timer.start(COYOTE_TIME)

func _on_state_hstate_changed(_old_hstate: PlayerState.hstates, new_hstate: PlayerState.hstates) -> void:
	tree.is_running = new_hstate == state.hstates.MOVE

func _on_state_orientation_changed(_old_orientation: PlayerState.orientations, new_orientation: PlayerState.orientations) -> void:
	if new_orientation == state.orientations.RIGHT:
		sprite.flip_h = false
		return
	sprite.flip_h = true
