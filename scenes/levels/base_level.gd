extends Node2D

class_name BaseLevel

@export var slice_scene: PackedScene
var level_slices: Array[LevelSlice] = []

@export var start_transition: TransitionArea
@export var end_transition: TransitionArea

@export var boundary: StaticBody2D

func instantiate_from_json(level_name: String) -> void:
	var raw_file = FileAccess.open("res://data/levels/{name}.json".format({"name": level_name}), FileAccess.READ).get_as_text()
	
	var file_json = JSON.new()
	var error = file_json.parse(raw_file)
	if error != OK: return

	var position_offset = 0
	var slice_widths = file_json.data["slice_width"]
	for slice_width in slice_widths:
		var new_slice: LevelSlice = slice_scene.instantiate()
		level_slices.append(new_slice)
		add_child(new_slice)

		var pixel_width = slice_width * LevelSlice.TILE_HEIGHT
		new_slice.set_width(pixel_width)
		new_slice.position.x = position_offset
		position_offset += pixel_width

		for x in range(slice_width):
			new_slice.foreground_map.set_cell(Vector2i(x, -1), 0, Vector2i(3, 5), 0)
			new_slice.foreground_map.set_cell(Vector2i(x, 34), 0, Vector2i(3, 5), 0)
	
	for index in range(level_slices.size()):
		level_slices[index].set_immovable(file_json.data["slice_locks"][index] == "0")
	
	for row in file_json.data["tiles"].keys():
		var y = int(row)
		var values = file_json.data["tiles"][row]

		var current_index: int = 0
		var threshold = slice_widths[0]
		var current_x = 0
		for x in range(60):
			if x >= threshold:
				current_index += 1
				threshold += slice_widths[current_index]
				current_x = 0
			if values[x] == "1": level_slices[current_index].foreground_map.set_cells_terrain_connect([Vector2i(current_x, y)], 0, 0)
			current_x += 1
	
	start_transition.position = Vector2(file_json.data["transition_start"][0], file_json.data["transition_start"][1])
	level_slices[0].space_moved.connect(start_transition.move)

	end_transition.position = Vector2(file_json.data["transition_end"][0], file_json.data["transition_end"][1])
	level_slices[level_slices.size() - 1].space_moved.connect(end_transition.move)
