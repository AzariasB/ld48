extends Node

enum PurchaseType {
	NONE,
	BASIC_DRILL,
	NORMAL_DRILL,
	ADVANCED_DRILL,
	LASER_DRILL
	
	BUCKET_O_WATER,
	COLD_WATER,
	CENTRAL_AIR_CONDITIONER,
	COOLING_LIQUID,
	
	GLOVES,
	SHOVEL,
	PICKAXE,
	EXCAVATOR,
	
	SIEVE,
	METAL_DETECTOR,
	MAGNET,
	SCANNER,
	
	ENGINE_REPAIR,
	IMPROVED_DRILL_ENGINE,
}

signal money_change(money)
signal temperature_change(temperature)
signal depth_change(depth)

signal money_used(money)
signal purchase_made(purchase_type)

signal end_reached()
