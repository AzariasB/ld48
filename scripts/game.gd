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
var auto_reparing = false

#Earth's radius in cm : 637800000

onready var temperature_node = $HBoxContainer/Temp/Temperature
onready var cooldown_node = $HBoxContainer/Temp/cooldown
onready var market_node = $Market
onready var money_node = $HBoxContainer/VBoxContainer/HBoxContainer/moneyValue
onready var depth_node = $HBoxContainer/Container/Depth
onready var end_node = $EndNode/Confeti
onready var buttons = [
	$HBoxContainer/VBoxContainer/dig,
	cooldown_node,
	$HBoxContainer/VBoxContainer/HBoxContainer/goMarket
]
onready var won_dialog = $WonDialog
onready var tool_node = $HBoxContainer/Container/GridContainer/ToolName
onready var moneygatherer_node = $HBoxContainer/Container/GridContainer/ToolName
onready var drill_node = $HBoxContainer/Container/GridContainer/Drill
onready var cooling_node = $HBoxContainer/Container/GridContainer/Drill

onready var click_sound = $Click

func _ready():
	randomize()
	set_process(false)
	depth_node.value = 0
	temperature_node.value = 0
	temperature_node.set_progress(0.0)
	global.connect("purchase_made", self, "_process_purchase")
	global.connect("money_used", self, "_loose_money")
	global.connect("max_temperature_reached", self, "_autorepair")
	global.connect("end_reached", self, "_finish_game", [], CONNECT_ONESHOT)

func _autorepair():
	if auto_reparing:
		self.temperature_node.set_progress(0.0)

func _finish_game():
	end_node.emitting = true
	end_node.amount = 100
	for b in self.buttons:
		b.disabled = true
	set_process(false)
	won_dialog.popup_centered_clamped()

func _menu_clicked():
	click_sound.play()
	Transition.fade_to("res://scenes/menu.tscn")

func _replay_clicked():
	click_sound.play()
	Transition.fade_to("res://scenes/game.tscn")

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
	if money != 0:
		self.money += money
		self.money_node.set_value(self.money)
		global.emit_signal("money_change", self.money)

func _loose_money(lost):
	self._gain_money(-lost)

func _manual_dig():
	$DigSound.pitch_scale = rand_range(0.5, 2.0)
	$DigSound.play()
	$".".add_child(load("res://scenes/DirtParticles.tscn").instance())
	self._increase_depth(dig_mult)
	# Debug only
	# self._gain_money(10)

func _cooldown():
	$CooldownSound.pitch_scale = rand_range(0.5, 2.0)
	$CooldownSound.play()
	$".".add_child(load("res://scenes/WaterParticles.tscn").instance())
	self.temperature_node.increase_progress(-1 * cooling_mult)
	global.emit_signal("temperature_change", self.temperature_node.value)

func _on_marked_pressed():
	$EnterShopSound.play()
	self.market_node.popup_centered()

func _process_purchase(purchase_type, name):
	$Purchase.pitch_scale = rand_range(0.7, 1.5)
	$Purchase.play()
	match purchase_type:
		global.PurchaseType.BASIC_DRILL_1:
			self.market_node.drill_bought()
			temperature_node.get_parent().visible = true
			set_process(true)
			drill_mult = 2
			tool_node.text = name
		global.PurchaseType.BASIC_DRILL_2:
			drill_mult  = 4
			tool_node.text = name
		global.PurchaseType.BASIC_DRILL_3:
			drill_mult = 6
			tool_node.text = name
		global.PurchaseType.BASIC_DRILL_4:
			drill_mult = 8
			tool_node.text = name
		global.PurchaseType.MECHANICAL_DRILL_1:
			drill_mult = 16
			tool_node.text = name
		global.PurchaseType.MECHANICAL_DRILL_2:
			drill_mult = 32
			tool_node.text = name
		global.PurchaseType.MECHANICAL_DRILL_3:
			drill_mult = 64
			tool_node.text = name
		global.PurchaseType.MECHANICAL_DRILL_4:
			drill_mult = 128
			tool_node.text = name
		global.PurchaseType.ELECTRIC_DRILL_1:
			drill_mult = 256
			tool_node.text = name
		global.PurchaseType.ELECTRIC_DRILL_2:
			drill_mult = 300
			tool_node.text = name
		global.PurchaseType.ELECTRIC_DRILL_3:
			drill_mult = 500
			tool_node.text = name
		global.PurchaseType.ELECTRIC_DRILL_4:
			drill_mult = 700
			tool_node.text = name
		global.PurchaseType.LASER_DRILL_1:
			drill_mult = 50_000
			tool_node.text = name
		global.PurchaseType.LASER_DRILL_2:
			drill_mult = 100_000
			tool_node.text = name
		global.PurchaseType.LASER_DRILL_3:
			drill_mult = 500_000
			tool_node.text = name
		global.PurchaseType.LASER_DRILL_4:
			drill_mult = 10_000_000
			tool_node.text = name
		global.PurchaseType.BUCKET_O_WATER:
			cooling_mult = 25
			cooling_node.text = name
		global.PurchaseType.COLD_WATER:
			cooling_mult = 100
			cooling_node.text = name
		global.PurchaseType.CENTRAL_AIR_CONDITIONER:
			heating_steps = 5
			cooling_node.text = name
		global.PurchaseType.COOLING_LIQUID:
			heating_steps = 1
			cooling_node.text = name
		global.PurchaseType.GLOVES_1:
			dig_mult = 2
			tool_node.name = name
		global.PurchaseType.GLOVES_2:
			dig_mult = 5
			tool_node.name = name
		global.PurchaseType.SHOVEL_1:
			dig_mult = 10
			tool_node.name = name
		global.PurchaseType.SHOVEL_2:
			dig_mult = 50
			tool_node.name = name
		global.PurchaseType.PICKAXE_1:
			dig_mult = 100
			tool_node.name = name
		global.PurchaseType.PICKAXE_2:
			dig_mult = 200
			tool_node.name = name
		global.PurchaseType.EXCAVATOR_1:
			dig_mult = 1000
			tool_node.name = name
		global.PurchaseType.EXCAVATOR_2:
			dig_mult = 2500
			tool_node.name = name
		global.PurchaseType.EXCAVATOR_3:
			dig_mult = 100_000
			tool_node.name = name
		global.PurchaseType.SIEVE:
			min_money = 5
			moneygatherer_node.text = name
			max_money = 15
		global.PurchaseType.METAL_DETECTOR:
			min_money = 15
			max_money = 20
			moneygatherer_node.text = name
		global.PurchaseType.MAGNET:
			min_money = 15
			max_money = 40
			moneygatherer_node.text = name
		global.PurchaseType.SCANNER_1:
			min_money = 30
			max_money = 50
			moneygatherer_node.text = name
		global.PurchaseType.SCANNER_2:
			min_money = 50
			max_money = 75
			moneygatherer_node.text = name
		global.PurchaseType.SCANNER_3:
			min_money = 60
			max_money = 100
			moneygatherer_node.text = name
		global.PurchaseType.ENGINE_REPAIR:
			self.temperature_node.set_progress(0.0)
		global.PurchaseType.IMPROVED_DRILL_ENGINE:
			self.temperature_node.max_value = 5000
		global.PurchaseType.ENGINE_AUTOREPAIR:
			self.auto_reparing = true


func _on_MusicToggle_pressed():
	click_sound.play()
	AudioServer.set_bus_mute(1, not AudioServer.is_bus_mute(1))
	


func _on_SoundToggle_pressed():
	click_sound.play()
	AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))


func _on_Pause_pressed():
	click_sound.play()
	get_tree().paused = not get_tree().paused

