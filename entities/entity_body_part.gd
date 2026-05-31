extends Area3D
class_name EntityBodyPart

var body: EntityBody
@export var id: String
@export var max_health: float = 10
@export var max_durability: float = 10 #hp before part is gone
@export var sharp_resistance: float = 1
@export var blunt_resistance: float = 1
@export var is_critical: bool
@export var debug: bool
var current_health: float
var current_durability: float


const MAX_BLUNT_BONUS: float = 1.5
const MIN_BLUNT_PENALTY: float = .1
const PARTIAL_PEN_THRESHOLD = 0.5
const FULL_PEN_THRESHOLD = 2

func _ready() -> void:
	current_health = max_health
	current_durability = max_durability

func hit(dmg: float, sharp_pen: float, blunt_pen: float, sharp_to_blunt_percent: float) -> void:
	var blunt_scale = clamp(blunt_pen / max(blunt_resistance, 0.01), MIN_BLUNT_PENALTY, MAX_BLUNT_BONUS)
	# FULL PENETRATION
	if sharp_pen >= sharp_resistance * FULL_PEN_THRESHOLD:
		current_health -= dmg + (dmg * sharp_to_blunt_percent * blunt_scale)
		current_durability -= dmg * max(sharp_resistance / sharp_pen, 0.01)

		if debug:
			print("part %s took %.2f damage. \n 
			sharp res: %.2f vs %.2f pen \n
			blunt res: %.2f vs %.2f pen \n
			FULL PENETRATION \n
			[%.2f sharp + %.2f blunt] \n
			%.2f(%.2f + %.2f) structural damage taken\n" % [id, 
			dmg + (dmg * sharp_to_blunt_percent * blunt_scale),
			sharp_resistance, sharp_pen,
			blunt_resistance, blunt_pen,
			dmg, (dmg * sharp_to_blunt_percent * blunt_scale),
			dmg * max(sharp_resistance / sharp_pen, 0.01),
			dmg, max(sharp_resistance / sharp_pen, 0.01)
			])
		
	# PARTIAL PENETRATION
	elif sharp_pen > sharp_resistance:
		var energy_retained = inverse_lerp(sharp_resistance, sharp_resistance * FULL_PEN_THRESHOLD, sharp_pen)

		var sharp_component = dmg * energy_retained
		var converted_blunt = (dmg - sharp_component) * sharp_to_blunt_percent
		
		current_health -= sharp_component + (converted_blunt * blunt_scale)
		current_durability -= (dmg * max(sharp_resistance / sharp_pen, 0.01)) * (1 - energy_retained)
		
		if debug:
			print("part %s took %.2f damage. \n 
			sharp res: %.2f vs %.2f pen \n
			blunt res: %.2f vs %.2f pen \n
			PARTIAL PENETRATION (%.2f%)\n
			[%.2f sharp + %.2f blunt] \n
			%.2f(%.2f%) structural damage taken\n" % [id, 
			dmg + (dmg * sharp_to_blunt_percent * blunt_scale),
			sharp_resistance, sharp_pen,
			blunt_resistance, blunt_pen,
			energy_retained*100,
			sharp_component, (converted_blunt * blunt_scale),
			(dmg * max(sharp_resistance / sharp_pen, 0.01)) * (1 - energy_retained),
			(1 - energy_retained)
			])

	# DEFLECTION
	else:
		var blunt_dmg = dmg * sharp_to_blunt_percent

		current_health -= blunt_dmg * blunt_scale
		current_durability -= blunt_dmg + ((blunt_dmg * blunt_scale) / 2)

		if debug:
			print("part %s took %.2f damage. \n 
			sharp res: %.2f vs %.2f pen \n
			blunt res: %.2f vs %.2f pen \n
			DEFLECTION (BLUNT) (%.2f at %.2f)\n
			[full blunt] \n
			%.2f(%.2f + %.2f) structural damage taken\n" % [id, 
			blunt_dmg * blunt_scale,
			sharp_resistance, sharp_pen,
			blunt_resistance, blunt_pen,
			dmg, sharp_to_blunt_percent,
			blunt_dmg + ((blunt_dmg * blunt_scale) / 2),
			blunt_dmg, ((blunt_dmg * blunt_scale) / 2)
			])

	if current_health <= 0:
		if is_critical:
			body.critical_destroyed(id)
		else:
			body.part_destroyed(id)
	else:
		body.part_damaged(id, current_health / max_health, float(current_durability) / max_durability)

	
	
