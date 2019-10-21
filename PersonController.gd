extends "Entity.gd"

var sProjectile = preload("Projectile.tscn")
var nLook : Node
var nHands : Node
export (float) var fRotateSpeed : float = 0.05
export (float) var fJumpStrength: float 
export (NodePath) var pLook : NodePath
export (NodePath) var pHands : NodePath
export (float) var fGroundSpeed: float 
export (float) var fAirSpeed: float 
var vMoveLook : Vector2 = Vector2.ZERO
var vMotion : Vector3 = Vector3.ZERO

func _ready():
	nLook = get_node(pLook)
	nHands = get_node(pHands)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta : float):
	move_camera(delta)
	apply_movement()
	
func shoot():
	var nProjectile = sProjectile.instance()
	nWorld.add_child(nProjectile)
	nProjectile.fRadius = 0.25
	nProjectile.set_rotation(get_rotation() + nLook.get_rotation())
	nProjectile.on_spawn()
	nProjectile.set_translation(nHands.get_global_transform().origin + get_rotation().normalized() * nProjectile.nCollider.get_shape().get_radius())
	
func jump():
	vVelocity.y += fJumpStrength
	
func apply_movement():
	if isGrounded():
		vVelocity += fGroundSpeed * transform.basis.xform(vMotion).normalized()
	else:
		vVelocity += fAirSpeed * transform.basis.xform(vMotion).normalized()
	vMotion = Vector3.ZERO
	
func move_camera(delta : float):
	var fMoveMod : float = PI * 2 * fRotateSpeed * delta
	rotate_y(min(fMoveMod * vMoveLook.x, nWorld.fMaxRotate))
	nLook.rotate_x(min(fMoveMod * vMoveLook.y, nWorld.fMaxRotate))
	vMoveLook = Vector2.ZERO
	var vRotation : Vector3 = nLook.get_rotation()
	vRotation.x = clamp(vRotation.x, -nWorld.fMaxLook, nWorld.fMaxLook)
	nLook.set_rotation(vRotation)
	vMoveLook = Vector2.ZERO