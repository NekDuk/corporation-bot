extends Node
class_name PlayerManager

@export var _max_energy: int = 200
var _current_energy 

func _ready() -> void:
	_current_energy = _max_energy

func get_energy() -> int:
	return _current_energy

func drain_energy(amount: int) -> void:
	_current_energy -= amount

func _process(delta: float) -> void:
	if _current_energy <= 0:
		print("NO MORE ENERGY")
