extends MarginContainer

const DEFAULT_WAIT_TIME = 0.3

var previous_var = 0
var display_value = 0

func _display_value(value: int):
	$moneyValue.text = str(value) + " €"

func _tween_step(value):
	_display_value(value)
	self.display_value = value

func set_value(value: int):
	if value != previous_var:
		$Tween.stop(self)
		$Tween.interpolate_method(self, 
			"_tween_step", 
			self.display_value,
			value,
			DEFAULT_WAIT_TIME,
			Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$Tween.start()
		$AnimationPlayer.play("Shake")
		var effect = load("res://scenes/MoneyChange.tscn").instance()
		effect.init(value - previous_var)
		add_child(effect)
		previous_var = value
