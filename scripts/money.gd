extends MarginContainer

const DEFAULT_WAIT_TIME = 0.1

var previous_var = 0

var target_var = 0
var wait_time = DEFAULT_WAIT_TIME

func _display_value(value: int):
	$moneyValue.text = str(value) + " €"

func _process(delta):
	if target_var != previous_var:
		var operation = sign(previous_var - target_var)
		var step = ceil(abs(previous_var - target_var) / 10.0)
		target_var += step * operation
		_display_value(target_var)

func set_value(value: int):
	if value != previous_var:
		$AnimationPlayer.play("Shake")
		var effect = load("res://scenes/MoneyChange.tscn").instance()
		effect.init(value - previous_var)
		add_child(effect)
		previous_var = value
