extends Node

enum PurchaseType {
	BASIC_DRILL,
	NORMAL_DRILL,
	ADVANCED_DRILL,
	LASER_DRILL
	
	BUCKET_O_WATER,
	COLD_WATER,
	CENTRAL_AIR_CONDITIONER,
	COOLING_LIQUID,
	
	METAL_DETECTOR
}

signal money_change(money)
signal temperature_change(temperature)
signal depth_change(depth)

signal money_used(money)
signal purchase_made(purchase_type)
