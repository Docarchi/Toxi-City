extends Node2D

@export var p_propagation = 0.6
var nb_heal = 0
var x_max = 20
var x_min = 3
var y_max = 9
var y_min = 2
@onready var label_timer = $HBoxContainer/label_timer
@onready var label_nb_heal = $HBoxContainer/label_nb_heal
@onready var pb_toxicity = $HBoxContainer/Pb_toxicity_level

func _ready() -> void:
	label_timer.start()
	$music_game.play()
	$Toxi_Propagation.timeout.connect(toxi_propagation)
	for tile_coord in $map_tiles.get_used_cells():
		var data = $map_tiles.get_cell_tile_data(tile_coord)
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)
		
func _input(event: InputEvent) -> void:
	var current_tile = $map_tiles.local_to_map(get_viewport().get_mouse_position()/$map_tiles.scale)
	if current_tile in $map_tiles.get_used_cells():
		if $map_tiles.get_cell_tile_data(current_tile).get_custom_data("type") == 1:
			if event is InputEventMouseButton and event.is_pressed():
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						$map_tiles.set_cell(current_tile, 0, Vector2i(0, 0))
						nb_heal += 1
					MOUSE_BUTTON_RIGHT:
						pass
				
func _process(delta: float) -> void:
	label_timer.set_text(str($Timer_left.get_time_left()).pad_decimals(1))
	label_nb_heal.text = str(nb_heal)
	pb_toxicity.max_value = int(round($map_tiles.get_used_cells().size()*0.75))
	var nb_toxic = 0
	for tile in $map_tiles.get_used_cells():
		if $map_tiles.get_cell_tile_data(tile).get_custom_data("toxic"):
			nb_toxic += 1
	pb_toxicity.value = lerp(pb_toxicity.value, float(nb_toxic), delta*3)

func found_neighbor(coord: Vector2i) -> Array:
	var delta : Array[Vector2i]
	if coord[0] % 2 == 0:
		delta = [Vector2i(0,-1), Vector2i(1,-1), Vector2i(1,0), Vector2i(0,1), 
		Vector2i(-1,0), Vector2i(-1,-1)]
	else:
		delta = [Vector2i(0,-1), Vector2i(1,0), Vector2i(1,1), Vector2i(0,1), 
		Vector2i(-1,1), Vector2i(-1,0)]
	var neighbors : Array[Vector2i]
	var used_cells = $map_tiles.get_used_cells()
	for d in delta:
		if coord +d in used_cells and !$map_tiles.get_cell_tile_data(coord +d).get_custom_data("toxic"):
			neighbors.append(coord + d)
	return neighbors
	
func toxi_propagation():
	var used_cells = $map_tiles.get_used_cells()
	var toxi_cells : Array[Vector2i]
	for tile in used_cells:
		if $map_tiles.get_cell_tile_data(tile).get_custom_data("toxic"):
			toxi_cells.append(tile)
	for tile in toxi_cells:
		for neighbor in found_neighbor(tile):
			if randf() > p_propagation:
				$map_tiles.set_cell(neighbor, 0, Vector2i(1, 0))


func _on_pb_toxicity_level_value_changed(value: float) -> void:
	if pb_toxicity.value == pb_toxicity.max_value:
		$Toxi_Propagation.stop()
		label_timer.stop()
		var victory_scene = load("res://main_menu.tscn")
		get_tree().change_scene_to_packed(victory_scene)


func _on_timer_left_timeout() -> void:
	for i in range(3):
		add_tile()
	add_toxicity()
	
func add_toxicity():
	var used_cells = $map_tiles.get_used_cells()
	var nb_cells = used_cells.size()
	var nb_r = randi_range(1, nb_cells)
	$map_tiles.set_cell(used_cells[nb_r-1], 0, Vector2i(1, 1))
	
func add_tile():
	var used_cells = $map_tiles.get_used_cells()
	var nb_cells = used_cells.size()
	var nb_r = randi_range(1, nb_cells)
	var neighbors = $map_tiles.get_surrounding_cells(used_cells[nb_r-1])
	for n in neighbors:
		if n not in used_cells and n[0] in range(3,20) and n[1] in range(2,9):
			$map_tiles.set_cell(n, 0, Vector2i(0, 0))
			break
