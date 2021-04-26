extends Control


var drill_temperature = 0
var drill_mult = 1
var drill_bonus = 0
var drilled_depth = 0.0
var heating_steps = 10
var cooling_mult = 5
var dig_mult = 1

var money = 0
var money_min_chance = -10
var money_max_chance = 1
var min_money = 1
var max_money = 10

#Earth's radius in mm : 6378000000

onready var temperature_node = $HBoxContainer/Temp/Temperature
onready var cooldown_node = $HBoxContainer/Temp/cooldown
onready var market_node = $Market
onready var money_node = $HBoxContainer/VBoxContainer/HBoxContainer/moneyValue
onready var depth_node = $HBoxContainer/Depth
onready var end_node = $EndNode/Confeti
onready var buttons = [
	$HBoxContainer/VBoxContainer/HBoxContainer2/dig,
	cooldown_node,
	$HBoxContainer/VBoxContainer/HBoxContainer/goMarket
]
onready var won_dialog = $WonDialog

func _ready():
	randomize()
	set_process(false)
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
	var won_money = round(rand_range(money_min_chance, money_max_chance))
	var money_made = 0
	if won_money > 0:
		money_made = round(rand_range(min_money, max_money))
	if money_made > 0:
		$NewMoney.pitch_scale = rand_range(0.7, 1.5)
		$NewMoney.play()
		self._gain_money(money_made)
	


func _process(delta):
	if self.temperature_node.value >= self.temperature_node.max_value:
		return
	
	self.drilled_depth += (delta * drill_mult + drill_bonus)
	if self.drilled_depth >= 1:
		var counted = floor(self.drilled_depth)
		self._increase_depth(counted)
		self.drilled_depth -= counted
		temperature_node.increase_progress(self.heating_steps)
	
func _gain_money(money):
	self.money += money
	self.money_node.text = str(self.money) + " €"
	global.emit_signal("money_change", self.money)

func _loose_money(lost):
	self._gain_money(-lost)

func _manual_dig():
	$DigSound.pitch_scale = rand_range(0.5, 2.0)
	$DigSound.play()
	var dirt_particles : Particles2D = load("res://scenes/DirtParticles.tscn").instance()
	$".".add_child(dirt_particles)
	self._increase_depth(dig_mult * 10)
	#Debug only
	#self._gain_money(100)

func _cooldown():
	$CooldownSound.pitch_scale = rand_range(0.5, 2.0)
	$CooldownSound.play()
	var water_particles : Particles2D = load("res://scenes/WaterParticles.tscn").instance()
	$".".add_child(water_particles)
	self.temperature_node.increase_progress(-1 * cooling_mult)
	global.emit_signal("temperature_change", self.temperature_node.value)

func _on_marked_pressed():
	$EnterShopSound.play()
	self.market_node.popup_centered()

func _process_purchase(purchase_type):
	$Purchase.pitch_scale = rand_range(0.7, 1.5)
	$Purchase.play()
	match purchase_type:
		global.PurchaseType.BASIC_DRILL_1:
			self.market_node.drill_bought()
			temperature_node.get_parent().visible = true
			set_process(true)
			drill_mult = 2
		global.PurchaseType.BASIC_DRILL_2:
			drill_mult  = 4
		global.PurchaseType.BASIC_DRILL_3:
			drill_mult = 6
		global.PurchaseType.BASIC_DRILL_4:
			drill_mult = 8
		global.PurchaseType.MECHANICAL_DRILL_1:
			drill_mult = 16
		global.PurchaseType.MECHANICAL_DRILL_2:
			drill_mult = 32
		global.PurchaseType.MECHANICAL_DRILL_3:
			drill_mult = 64
		global.PurchaseType.MECHANICAL_DRILL_4:
			drill_mult = 128
		global.PurchaseType.ELECTRIC_DRILL_1:
			drill_mult = 256
		global.PurchaseType.ELECTRIC_DRILL_2:
			drill_mult = 300
		global.PurchaseType.ELECTRIC_DRILL_3:
			drill_mult = 500
		global.PurchaseType.ELECTRIC_DRILL_4:
			drill_mult = 700
		global.PurchaseType.LASER_DRILL_1:
			drill_mult = 50_000
		global.PurchaseType.LASER_DRILL_2:
			drill_mult = 100_000
		global.PurchaseType.LASER_DRILL_3:
			drill_mult = 500_000
		global.PurchaseType.LASER_DRILL_4:
			drill_mult = 10_000_000
		global.PurchaseType.BUCKET_O_WATER:
			cooling_mult = 25
		global.PurchaseType.COLD_WATER:
			cooling_mult = 100
		global.PurchaseType.CENTRAL_AIR_CONDITIONER:
			heating_steps = 5
		global.PurchaseType.COOLING_LIQUID:
			heating_steps = 1
		global.PurchaseType.GLOVES_1:
			dig_mult = 2
		global.PurchaseType.GLOVES_2:
			dig_mult = 5
		global.PurchaseType.SHOVEL_1:
			dig_mult = 10
		global.PurchaseType.SHOVEL_2:
			dig_mult = 50
		global.PurchaseType.PICKAXE_1:
			dig_mult = 100
		global.PurchaseType.PICKAXE_2:
			dig_mult = 200
		global.PurchaseType.EXCAVATOR_1:
			dig_mult = 1000
		global.PurchaseType.EXCAVATOR_2:
			dig_mult = 2500
		global.PurchaseType.EXCAVATOR_3:
			dig_mult = 100_000
		global.PurchaseType.SIEVE:
			min_money = 5
			max_money = 15
		global.PurchaseType.METAL_DETECTOR:
			min_money = 15
			max_money = 20
		global.PurchaseType.MAGNET:
			min_money = 15
			max_money = 40
		global.PurchaseType.SCANNER_1:
			min_money = 30
			max_money = 50
		global.PurchaseType.SCANNER_2:
			min_money = 50
			max_money = 75
		global.PurchaseType.SCANNER_3:
			min_money = 60
			max_money = 100
		global.PurchaseType.ENGINE_REPAIR:
			self.temperature_node.set_progress(0.0)
		global.PurchaseType.IMPROVED_DRILL_ENGINE:
			self.temperature_node.max_value = 5000
