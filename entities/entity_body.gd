extends Node
class_name EntityBody

@export var parts: Array[EntityBodyPart]

func _ready() -> void:
	for p in parts:
		p.body = self

func critical_destroyed(_id: String) -> void:
	pass

func part_destroyed(_id: String) -> void:
	pass

func part_damaged(_id: String, _health_percent: float, _integrity_percent) -> void:
	pass
