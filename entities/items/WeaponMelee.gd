extends Node
class_name WeaponMelee

@export var _data: Weapon
@export var _anim_delay: float = 1.0 # delay for animations to play
var _attack_timer: float = 0

func attack() -> void:
	if _attack_timer > 0:
		return
	
	_attack_timer = 0
	# start attack anim


func _process(delta) -> void:
	_attack_timer -= delta


