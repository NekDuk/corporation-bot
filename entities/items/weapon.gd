extends Resource
class_name Weapon

@export var damage: int = 10
@export var attack_speed: float = 1 # cooldown in secs
enum WeaponType {Melee, Projectile, Hitscan}
@export var type: WeaponType = WeaponType.Melee
@export var name: String = "Weapon Name"
