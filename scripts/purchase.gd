extends PanelContainer

export(int) var price = 0
export(String) var text = "Name"
export(global.PurchaseType) var purchase_type = global.PurchaseType.NONE
export(global.PurchaseType) var required_purchase = global.PurchaseType.NONE
export(bool) var one_use = true

var has_previous_purchase = false
var has_enough_money = false
var bought = false

onready var button_node = $HBoxContainer/Button
onready var text_node = $HBoxContainer/Title
onready var price_node = $HBoxContainer/Price
onready var check_node = $HBoxContainer/Check

func _ready():
	self.has_previous_purchase = self.required_purchase == global.PurchaseType.NONE
	self.has_enough_money = false
	self.button_node.disabled = true
	self.text_node.text = text
	self.price_node.text = str(price) + "€"
	global.connect("money_change", self, "_money_changed")
	global.connect("purchase_made", self, "_update_condition")

func _update_condition(purchase_type):
	if self.has_previous_purchase or self.bought:
		return
	self.has_previous_purchase = purchase_type == self.required_purchase
	self._update_internal_state()

func _money_changed(money):
	if self.bought:
		return
	self.has_enough_money = self.price <= money
	self._update_internal_state()
	

func _update_internal_state():
	if has_enough_money and has_previous_purchase:
		self.button_node.disabled = false
		self.button_node.connect("pressed", self, "_do_purchase")
	else:
		self.button_node.disabled = true


func _do_purchase():
	global.emit_signal("money_used", self.price)
	if one_use:
		self.bought = true
		self.check_node.visible = true
		self.price_node.visible = false
		self.button_node.visible = false
	global.emit_signal("purchase_made", self.purchase_type)
