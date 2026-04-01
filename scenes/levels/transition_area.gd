extends Area2D

class_name TransitionArea

@export var attached_slice: LevelSlice

const SCREEN_HEIGHT = 540

signal player_entered

func _ready() -> void:
	attached_slice.space_moved.connect(move)

func move(amount: float) -> void:
	position.y = fmod(position.y + amount, SCREEN_HEIGHT)
	if position.y < 0: position.y += SCREEN_HEIGHT + 20

func _on_transition_area_body_entered(body: Node2D) -> void:
	if (body.is_in_group("player")): player_entered.emit()