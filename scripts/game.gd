extends Control


var drill_temperature = 0
var drill_mult = 1
var drill_bonus = 0
var drilled_depth = 0.0
var heating_steps = 10
var cooling_mult = 1
var dig_mult = 1

var money = 0
var min_money = -5
var max_money = 1

#Earth's radius in mm : 6378000000

onready var temperature_node = $HBoxContainer/Temperature
onready var market_node = $Market
onready var money_node = $HBoxContainer/VBoxContainer/HBoxContainer/moneyValue
onready var logs_dialog = $HBoxContainer/VBoxContainer/HBoxContainer4/logs
onready var depth_node = $HBoxContainer/Depth
onready var end_node = $EndNode/Confeti
onready var buttons = [
	$HBoxContainer/VBoxContainer/HBoxContainer2/dig,
	$HBoxContainer/VBoxContainer/HBoxContainer2/cooldown,
	$HBoxContainer/VBoxContainer/HBoxContainer3/goMarket
]
onready var won_dialog = $WonDialog

func _ready():
	depth_node.value = 0
	temperature_node.value = 0
	temperature_node.set_progress(0.0)
	global.connect("purchase_made", self, "_process_purchase")
	global.connect("money_used", self, "_loose_money")

	global.connect("end_reached", self, "_finish_game", [], CONNECT_ONESHOT)

func _finish_game():
	end_node.emitting = true
	end_node.amount = 100
	for b in self.buttons:
		b.disabled = true
	set_process(false)
	won_dialog.popup_centered_clamped()

func _menu_clicked():
	get_tree().change_scene("res://scenes/menu.tscn")

func _replay_clicked():
	get_tree().change_scene("res://scenes/game.tscn")

func _increase_depth(depth):
	depth_node.value += depth
	global.emit_signal("depth_change", depth_node.value)
	var money_made = round(rand_range(min_money, max_money))
	if money_made > 0:
		self.logs_dialog.text += "Found " + str(money_made) + "€!\n"
		self._gain_money(money_made)
	


func _process(delta):
	if self.temperature_node.value >= self.temperature_node.max_value:
		return
	
	self.drilled_depth += (delta * drill_mult + drill_bonus)
	if self.drilled_depth >= 1:
		self.drilled_depth -= 1
		temperature_node.increase_progress(self.heating_steps)
		self._increase_depth(1)
	
func _gain_money(money):
	self.money += money
	self.money_node.text = str(self.money) + " €"
	global.emit_signal("money_change", self.money)

func _loose_money(lost):
	self._gain_money(-lost)

func _manual_dig():
	self._increase_depth(dig_mult * 10000000000)
	#Debug only
	self._gain_money(100)

func _cooldown():
	self.temperature_node.increase_progress(-1 * cooling_mult)
	global.emit_signal("temperature_change", self.temperature_node.value)

func _on_marked_pressed():
	self.market_node.popup_centered()

func _process_purchase(purchase_type):
	match purchase_type:
		global.PurchaseType.BASIC_DRILL:
			drill_mult = 2
		global.PurchaseType.NORMAL_DRILL:
			drill_mult  = 4
		global.PurchaseType.ADVANCED_DRILL:
			drill_mult = 6
		global.PurchaseType.LASER_DRILL:
			drill_mult = 8
		global.PurchaseType.BUCKET_O_WATER:
			cooling_mult = 2
		global.PurchaseType.CENTRAL_AIR_CONDITIONER:
			heating_steps = 5
		global.PurchaseType.COLD_WATER:
			cooling_mult = 5
		global.PurchaseType.COOLING_LIQUID:
			heating_steps = 1
		global.PurchaseType.GLOVES:
			dig_mult = 2
		global.PurchaseType.SHOVEL:
			dig_mult = 5
		global.PurchaseType.PICKAXE:
			dig_mult = 10
		global.PurchaseType.EXCAVATOR:
			dig_mult = 50
		global.PurchaseType.SIEVE:
			min_money = -2
			max_money = 2
		global.PurchaseType.METAL_DETECTOR:
			min_money = -1
			max_money = 3
		global.PurchaseType.MAGNET:
			min_money = -1
			max_money = 5
		global.PurchaseType.SCANNER:
			min_money = 0
			max_money = 10
		global.PurchaseType.ENGINE_REPAIR:
			self.temperature_node.set_progress(0.0)
		global.PurchaseType.IMPROVED_DRILL_ENGINE:
			self.temperature_node.max_value = 5000
