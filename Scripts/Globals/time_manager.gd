extends Node

var hours = 6
var minutes = 0
var ampm = "am"
var current_time: String
var current_day = 0
var current_number_day = 1
var current_date: String
var current_season = 0

signal new_day
signal new_season

func update_time():
	if minutes < 50:
		minutes += 10
	else:
		minutes = 0
		hours += 1
		check_ampm()
	
	if hours == 12 and ampm == "am":
		hours = 0
	
	if hours > 12:
		hours -= 12
	
	if hours == 2 and ampm == "am":
		next_day()
	
	current_time = "%02d:%02d %s" %[hours, minutes, ampm]
	


func next_day():
	new_day.emit()
	hours = 6
	minutes = 0
	current_day += 1
	current_number_day += 1
	
	if current_day == 7:
		current_day = 0
	
	if current_number_day > 28:
		current_number_day = 1
		next_season()


func next_season():
	match current_season:
		0:
			new_season.emit(DataTypes.Seasons.SUMMER)
		1:
			new_season.emit(DataTypes.Seasons.FALL)
		2:
			new_season.emit(DataTypes.Seasons.WINTER)
		3:
			new_season.emit(DataTypes.Seasons.SPRING)
	
	current_season += 1
	if current_season == 4:
		current_season = 0


func get_time():
	current_time = "%02d:%02d %s" %[hours, minutes, ampm]
	return current_time


func get_date():
	current_date = DataTypes.day_text[current_day] + ". " + str(current_number_day)
	return current_date


func check_ampm():
	if hours == 12:
		if ampm == "am":
			ampm = "pm"
		else:
			ampm = "am"
