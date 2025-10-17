extends Sprite2D

var selected_crop
var day = 0
var watered = false
var harvest_ready = false
var withered = false
var growth_days
var crop_name
var season

func _ready() -> void:
	get_parent().connect("day_changed", on_day_changed)
	
	frame_coords = CropsData.crops_info[selected_crop].frame_coords
	growth_days = CropsData.crops_info[selected_crop].growth_days
	crop_name = CropsData.crops_info[selected_crop].name
	season = CropsData.crops_info[selected_crop].season


func next_stage():
	if day < growth_days:
		day += 1
		frame += CropsData.get_stage(selected_crop, day)
	if day == growth_days:
		harvest_ready = true
		print(crop_name + " ready to harvest")


func on_day_changed(watered_tiles) -> void:
	check_watered(watered_tiles)
	if watered and not withered:
		next_stage()
	check_seasonal_crops()


func check_seasonal_crops():
	var crops = get_tree().get_nodes_in_group("crops")
	for crop in crops:
		if crop.withered:
			continue
		if crop.season != TimeManager.current_season:
			crop.wilt_crop()


func check_watered(watered_tiles):
	@warning_ignore("narrowing_conversion")
	var pos = Vector2i(position.x / 16, position.y / 16)
	if pos in watered_tiles:
		watered = true


func wilt_crop():
	frame = CropsData.get_random_dead_crop()
	withered = true
