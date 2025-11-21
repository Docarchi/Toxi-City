extends Label

var elapsed_time: float = 0.0
var running: bool = false


func _process(delta):
	if running:
		elapsed_time += delta
	self.set_text(format_time(elapsed_time))

func start():
	running = true

func stop():
	running = false

func reset():
	running = false
	elapsed_time = 0.0

func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	var millis = int((seconds - int(seconds)) * 100)
	return "%02d:%02d.%02d" % [minutes, secs, millis]
