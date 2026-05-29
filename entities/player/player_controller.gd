extends Node
class_name PlayerController

@onready var _controller = $"../Entity/Controller" as EntityController
@onready var _body = get_parent() as CharacterBody3D
@onready var _manager = get_parent() as PlayerManager
@export var _speed: float = 10
@export var _sprint_scale: float = 1.5
@export var _drain_speed: float = 1
@export var _sprint_min_threshold: int = 30
var _drain_timer: float = 0
var _drain_amt: int = 1
var _sprinting: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not (_controller or _body):
		return

	if Input.is_action_pressed("move_sprint") and _manager.get_energy() > _sprint_min_threshold:
		_sprinting = true
		if _drain_timer >= _drain_speed:
			_drain_timer = 0
			_manager.drain_energy(_drain_amt)
		else:
			_drain_timer += delta
	else:
		_sprinting = false

	if _sprinting:
		_controller.set_speed(_speed * _sprint_scale)
	else:
		_controller.set_speed(_speed)


	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction: Vector3 = (_body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	_controller.move(direction)
	
	if Input.is_action_just_pressed("move_jump"):
		_controller.jump()
