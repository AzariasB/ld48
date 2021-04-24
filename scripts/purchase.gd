extends PanelContainer

export(int) var price = 0
export(String) var text = "Name"
export(global.PurchaseType) var purchase_type = global.PurchaseType.NORMAL_DRILL

var bought = false

onready var button_node = $HBoxContainer/Button
onready var text_node = $HBoxContainer/Title
onready var price_node = $HBoxContainer/Price

func _ready():
	self.button_node.disabled = true
	self.text_node.text = text
	self.price_node.text = str(price) + "€"
	global.connect("money_change", self, "_money_changed")
	

func _money_changed(money):
	if self.bought:
		return
	if money >= self.price:
		self.button_node.disabled = false
		self.button_node.connect("pressed", self, "_do_purchase")
	else:
		self.button_node.disabled = true
		self.button_node.disconnect("pressed", self, "_do_purchase")


func _do_purchase():
	global.emit_signal("money_used", self.price)
	self.button_node.disabled = true
	self.button_node.disconnect("pressed", self, "_do_purchase")
	self.bought = true
	global.emit_signal("purchase_made", self.purchase_type)
