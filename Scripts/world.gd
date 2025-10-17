extends Node2D

@onready var backgrounnd_layer: TileMapLayer = $TileMapLayers/Backgrounnd
@onready var dirt_layer: TileMapLayer = $TileMapLayers/Dirt
@onready var watered_dirt_layer: TileMapLayer = $TileMapLayers/WateredDirt


const DIRT_ANIMATION = preload("uid://bx811a21ae33u")
const WATERED_ANIMATION = preload("uid://ltitoh6m62kq")
const CROP = preload("uid://bx46kn8a21en8")


var can_hoe_data = "can_hoe"
var can_seed_data = "can_seed"

var dirt_tiles = []
var watered_tiles = []
var seed_tiles = []

var actual_season = TimeManager.current_season
var current_tool = DataTypes.Tools.NONE
var current_crop = DataTypes.Crops.NONE
var actual_terrain = DataTypes.SeasonsTerrain.NORMAL

#var day = 1

signal day_changed(watered_crops)

func _ready() -> void:
	ToolManager.tool_selected.connect(on_tool_selected)
	ToolManager.crop_selected.connect(on_crop_selected)
	TimeManager.connect("new_day", new_day)
	TimeManager.connect("new_season", change_season)


func new_day():
	day_changed.emit(watered_tiles)


func on_tool_selected(tool: DataTypes.Tools):
	current_tool = tool


func on_crop_selected(crop: DataTypes.Crops):
	current_crop = crop


func _input(_event: InputEvent) -> void:
	var mouse_pos = get_global_mouse_position()
	var tile_mouse_pos = dirt_layer.local_to_map(mouse_pos)
	
	if Input.is_action_just_pressed("spring"):
		change_season(DataTypes.Seasons.SPRING)
	
	if Input.is_action_just_pressed("summer"):
		change_season(DataTypes.Seasons.SUMMER)
	
	if Input.is_action_just_pressed("fall"):
		change_season(DataTypes.Seasons.FALL)
	
	if Input.is_action_just_pressed("winter"):
		change_season(DataTypes.Seasons.WINTER)
	
	if Input.is_action_pressed("click"):
		if current_tool == DataTypes.Tools.HOE:
			if get_custom_data(backgrounnd_layer, tile_mouse_pos, can_hoe_data):
				if tile_mouse_pos not in dirt_tiles:
					dirt_tiles.append(tile_mouse_pos)
					dirt_layer.set_cells_terrain_connect(dirt_tiles, 0, actual_terrain)
					inst_animation(DIRT_ANIMATION, tile_mouse_pos)
		
		if current_tool == DataTypes.Tools.WATERING_CAN:
			if get_custom_data(dirt_layer, tile_mouse_pos, can_seed_data):
				if tile_mouse_pos not in watered_tiles:
					watered_tiles.append(tile_mouse_pos)
					watered_dirt_layer.set_cells_terrain_connect(watered_tiles, 0, actual_terrain)
					inst_animation(WATERED_ANIMATION, tile_mouse_pos)
		
		if current_tool == DataTypes.Tools.SEED:
			if get_custom_data(dirt_layer, tile_mouse_pos, can_seed_data):
				if tile_mouse_pos not in seed_tiles:
					seed_tiles.append(tile_mouse_pos)
					place_crop(current_crop, tile_mouse_pos)


func place_crop(crop, pos):
	var new_crop = CROP.instantiate()
	var fix_position = Vector2(pos.x * 16, pos.y * 16)
	new_crop.position = fix_position
	new_crop.crop = crop
	new_crop.z_index = pos.y
	add_child(new_crop)


func get_custom_data(tile_map_layer, tile, custom_data_layer):
	var tile_data = tile_map_layer.get_cell_tile_data(tile)
	
	if tile_data:
		return tile_data.get_custom_data(custom_data_layer)
	else:
		return false


func inst_animation(animation, pos):
	var inst = animation.instantiate()
	var fix_position = Vector2(pos.x * 16, pos.y * 16)
	inst.position = fix_position
	add_child(inst)
	inst.play("hoed")


func change_season(season):
	var background_cells = backgrounnd_layer.get_used_cells()
	var dirt_cells = dirt_layer.get_used_cells()
	var watered_cells = watered_dirt_layer.get_used_cells()
	
	if actual_season == season:
		print("It's already " + DataTypes.seasons_text[season])
		return
	
	for cell in background_cells:
		var atlas_coords = backgrounnd_layer.get_cell_atlas_coords(cell)
		backgrounnd_layer.set_cell(cell, season, atlas_coords)
	
	if season == DataTypes.Seasons.WINTER:
		actual_terrain = DataTypes.SeasonsTerrain.WINTER
	else:
		actual_terrain = DataTypes.SeasonsTerrain.NORMAL
	
	dirt_layer.set_cells_terrain_connect(dirt_cells, 0, actual_terrain)
	watered_dirt_layer.set_cells_terrain_connect(watered_cells, 0, actual_terrain)
	
	actual_season = season
	check_seasonal_crops()
	
	print("Season: " + DataTypes.seasons_text[season])


func check_seasonal_crops():
	var crops = get_tree().get_nodes_in_group("crops")
	for crop in crops:
		if crop.withered:
			continue
		if crop.season != actual_season:
			get_tree().call_group("crops", "wilt_crop")
