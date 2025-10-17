extends Node2D

var crops_info = [
	{
		name = "Parsnip",
		growth_days = 4,
		season = DataTypes.Seasons.SPRING,
		stages_sequence = [0, 1, 1, 1, 1],
		frame_coords = Vector2i(1, 0),
		},
	{
		name = "Potato",
		growth_days = 6,
		season = DataTypes.Seasons.SPRING,
		stages_sequence = [0, 1, 1, 1, 0, 1, 1],
		frame_coords = Vector2i(9, 1),
		},
	{
		name = "Blueberry",
		growth_days = 13,
		season = DataTypes.Seasons.SPRING,
		stages_sequence = [0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 1],
		frame_coords = Vector2i(9, 4),
		},
]

var dead_crop_sprite_frames = [204, 205, 206, 207]
var crop_list : Dictionary


func get_stage(crop, day):
	return crops_info[crop].stages_sequence[day]


func get_random_dead_crop():
	var rng = RandomNumberGenerator.new()
	
	var random_dead_crop = rng.randi_range(0, 3)
	return dead_crop_sprite_frames[random_dead_crop]
