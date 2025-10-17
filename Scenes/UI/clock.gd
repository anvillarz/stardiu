extends TextureRect

@onready var season_rect: TextureRect = $Season
@onready var weather_rect: TextureRect = $Weather
@onready var time_label: Label = $Time
@onready var date_label: Label = $Date

var seasons_data = [
	{
		season = "Spring",
		region = Rect2(80, 0, 12, 8),
		},
	{
		season = "Summer",
		region = Rect2(93, 0, 12, 8),
		},
	{
		season = "Fall",
		region = Rect2(106, 0, 12, 8),
		},
	{
		season = "Winter",
		region = Rect2(119, 0, 12, 8),
		},
]


func _ready() -> void:
	TimeManager.connect("new_season", update_season_rect)
	update_clock_time()


func update_season_rect(season):
	season_rect.texture.set_region(seasons_data[season].region)


func _on_timer_timeout() -> void:
	TimeManager.update_time()
	update_clock_time()
	update_date()


func update_clock_time():
	time_label.text = TimeManager.get_time()
	for shadow in time_label.get_children():
		shadow.text = TimeManager.get_time()


func update_date():
	date_label.text = TimeManager.get_date()
	for shadow in date_label.get_children():
		shadow.text = TimeManager.get_date()
