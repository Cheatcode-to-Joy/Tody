extends Node

class_name PlayerState

@export var player: PlayerCharacter

enum vstates { STAND, JUMP, FALL }
var vstate: vstates = vstates.STAND
signal player_vstate_changed(new_state: vstates)

enum hstates { STAY, MOVE }
var hstate: hstates = hstates.STAY
signal player_hstate_changed(new_state: hstates)

enum orientations { LEFT, RIGHT }
var orientation: orientations = orientations.RIGHT
signal player_orientation_changed(new_state: orientations)

func _physics_process(_delta: float) -> void:
	process_vstates()
	process_hstates()
	process_orientations()

func process_vstates() -> void:
	if player.is_on_floor():
		if vstate != vstates.STAND:
			vstate = vstates.STAND
			player_vstate_changed.emit(vstate)
		return
	if player.velocity.y < 0:
		if vstate != vstates.JUMP:
			vstate = vstates.JUMP
			player_vstate_changed.emit(vstate)
		return
	if vstate != vstates.FALL:
		vstate = vstates.FALL
		player_vstate_changed.emit(vstate)

func process_hstates() -> void:
	var action_strength = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if is_zero_approx(action_strength):
		if hstate != hstates.MOVE:
			hstate = hstates.STAY
			player_hstate_changed.emit(hstate)
		return
	if hstate != hstates.MOVE:
		hstate = hstates.MOVE
		player_hstate_changed.emit(hstate)

func process_orientations() -> void:
	var action_strength = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if is_zero_approx(action_strength):
		return
	if action_strength > 0:
		if orientation != orientations.RIGHT:
			orientation = orientations.RIGHT
			player_orientation_changed.emit(orientation)
		return
	if orientation != orientations.LEFT:
		orientation = orientations.LEFT
		player_orientation_changed.emit(orientation)