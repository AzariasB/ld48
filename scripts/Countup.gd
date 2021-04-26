extends Node


var total = 0.0


func _to_time():
	var val = int(round(total))
	if val < 60:
		return str(val) + "s"
	
	var seconds = val % 60
	val = (val - seconds) / 60
	seconds = "" if seconds == 0 else str(seconds) + "s"
	if val < 60:
		return  str(val) + "mn "  + seconds
	
	var minutes = val % 60
	val = (val - minutes) / 60
	minutes = "" if minutes == 0 else str(minutes) + "mn"
	return PoolStringArray([str(val) + "hr", minutes, seconds]).join(" ")

func _process(delta):
	total += delta
