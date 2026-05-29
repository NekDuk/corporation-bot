extends Camera3D

@onready var _body = get_parent() as CharacterBody3D
@export var _mouse_sensitivity = 0.001
@export var _pitch_clamp = 80.0 # degrees
var _yaw = 0.0
var _pitch = 0.0


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
			_yaw -= event.relative.x * _mouse_sensitivity
			_pitch -= event.relative.y * _mouse_sensitivity
			var pitch_clamp_rad = deg_to_rad(_pitch_clamp)
			_pitch = clampf(_pitch, -pitch_clamp_rad, pitch_clamp_rad)
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	_body.basis = Basis.from_euler(Vector3(0, _yaw, 0))
	rotation.x = _pitch
