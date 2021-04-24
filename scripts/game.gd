extends Control


var drill_temperature = 0
var depth = 0
var drill_mult = 1
var drill_bonus = 0
var drilled_depth = 0.0
var cooling_mult = 1

var money = 0
var min_money = -5
var max_money = 1

const MAX_DEPTH = 6_378_000_000

onready var depth_node = $HBoxContainer/Depth
onready var temperature_node = $HBoxContainer/Temperature
onready var market_node = $Market
onready var money_node = $HBoxContainer/VBoxContainer/HBoxContainer/moneyValue
onready var logs_dialog = $HBoxContainer/VBoxContainer/HBoxContainer4/logs

func _ready():
	depth_node.value = 0
	depth_node.max_value = MAX_DEPTH
	temperature_node.value = 0
	depth_node.set_progress(0.0, "mm")
	temperature_node.set_progress(0.0, "°C")
	global.connect("purchase_made", self, "_process_purchase")
	global.connect("money_used", self, "_loose_money")

func _increase_depth(depth):
	depth_node.increase_progress(depth)
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
		temperature_node.increase_progress(1)
		self._increase_depth(1)
	
func _gain_money(money):
	self.money += money
	self.money_node.text = str(self.money) + " €"
	global.emit_signal("money_change", self.money)

func _loose_money(lost):
	self._gain_money(-lost)

func _manual_dig():
	self._increase_depth(1)
	#Debug only
	self._gain_money(1)

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
			cooling_mult = 3
		global.PurchaseType.COLD_WATER:
			cooling_mult = 4
		global.PurchaseType.COOLING_LIQUID:
			cooling_mult = 5
