extends Node
class_name EntityController

@onready var _cb = owner as CharacterBody3D # Main Character Body
@export var _speed = 5.0
@export var _brake_speed = 5.0
@export var _jump_velocity = 4.5
@export var _air_move_scale = 0.2 # 1 - full movement in air, 0 - no movement; velocity retained

func set_speed(s: float) -> void:
	_speed = s

func jump() -> void:
	if _cb.is_on_floor():
		_cb.velocity.y = _jump_velocity

func move(direction: Vector3) -> void:
	if not _cb.is_on_floor():
		if _air_move_scale == 0:
			return
		else:
			var x_vel = direction.x * _speed
			var z_vel = direction.z * _speed
			if direction == Vector3.ZERO:
				x_vel = 0
				z_vel = 0

			_cb.velocity.x = move_toward(_cb.velocity.x, x_vel, _air_move_scale)
			_cb.velocity.z = move_toward(_cb.velocity.z, z_vel, _air_move_scale)
	else:
		if direction != Vector3.ZERO:
			_cb.velocity.x = direction.x * _speed
			_cb.velocity.z = direction.z * _speed
		else:
			_cb.velocity.x = move_toward(_cb.velocity.x, 0, _brake_speed)
			_cb.velocity.z = move_toward(_cb.velocity.z, 0, _brake_speed)
		

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not _cb.is_on_floor():
		_cb.velocity += _cb.get_gravity() * delta

	_cb.move_and_slide()
