extends CanvasLayer

@onready var clock: TextureRect = $MarginContainer/Clock
var timer: Timer

func _on_sleep_button_pressed() -> void:
	timer = clock.get_node("Timer")
	timer.stop()
	TimeManager.next_day()
	clock.update_clock_time()
	clock.update_date()
	timer.start()
