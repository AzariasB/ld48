extends MarginContainer

var previous_var = 0

func set_value(value: int):
	if value != previous_var:
		$AnimationPlayer.play("Shake")
		$moneyValue.text = str(value) + " €"
		var effect = load("res://scenes/MoneyChange.tscn").instance()
		effect.init(value - previous_var)
		add_child(effect)
		previous_var = value
