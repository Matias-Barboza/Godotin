class_name Godotin
extends KinematicBody


const direccion_arriba : Vector3 = Vector3.UP


enum {SUELO, AIRE}


export var velocidad_max : Vector2 = Vector2(10.0, 60.0)
export var gravedad : float = 9.8
export var impulso : float = 50.0
export var fuerza_salto : float = 18.0


var movimiento: Vector3 = Vector3.ZERO
var vector_snap : Vector3 = Vector3.DOWN
var salto_interrumpido : bool = false
var saltando : bool = false
var cayendo : bool = false


onready var armadura : Spatial = $Armadura
onready var brazo_camara : SpringArm = $BrazoCamara
onready var arbol_animacion : ArbolDeAnimacionPlayer = $ArbolDeAnimacion


func _physics_process(delta: float) -> void:
	
	movimiento_horizontal()
	
	movimiento_vertical()
	
	movimiento = move_and_slide_with_snap(movimiento, vector_snap, direccion_arriba, true)
	
	var direccion_vista_player = Vector2(movimiento.z, movimiento.x)
	
	if direccion_vista_player.length() > 0:
		armadura.rotation.y = direccion_vista_player.angle()


func _process(delta: float) -> void:
	
	brazo_camara.translation = translation


func tomar_direccion() -> Vector3:
	
	var direccion : Vector3 = Vector3.ZERO
	
	direccion.x = Input.get_action_strength("mov_derecha") - Input.get_action_strength("mov_izquierda")
	direccion.z = Input.get_action_strength("mov_atras") - Input.get_action_strength("mov_adelante")
	
	arbol_animacion.set_valor_mezcla_idle_caminar(direccion.length())
	direccion = direccion.rotated(Vector3.UP, brazo_camara.rotation.y).normalized()
	
	return direccion


func movimiento_horizontal() -> void:
	
	movimiento.x = tomar_direccion().x * velocidad_max.x
	movimiento.z = tomar_direccion().z * velocidad_max.x


func movimiento_vertical() -> void:
	
	if not is_on_floor():
		
		movimiento.y -= gravedad
		movimiento.y = clamp(movimiento.y, -velocidad_max.y, impulso)
		if Input.is_action_just_released("saltar"):
			salto_interrumpido = true
	else:
		saltando = false
	
	var tocando_suelo : bool = is_on_floor() and vector_snap == Vector3.ZERO
	var inicio_salto : bool = is_on_floor() and Input.is_action_just_pressed("saltar")
	
	if inicio_salto:
		
		arbol_animacion.set_transicion_suelo_aire(AIRE)
		arbol_animacion.set_mezcla_saltar_caer(0)
		vector_snap = Vector3.ZERO
		saltando = true
		salto_interrumpido = false
		cayendo = false
	elif tocando_suelo:
		
		arbol_animacion.set_transicion_suelo_aire(SUELO)
		vector_snap = Vector3.DOWN
	
	if movimiento.y >= velocidad_max.y:
		
		salto_interrumpido = true
	
	if Input.is_action_pressed("saltar") and saltando and not salto_interrumpido:
		
		movimiento.y += fuerza_salto
	
	
	if movimiento.y <= 0 and not cayendo:
		
		cayendo = true
		for i in range(1, 11, 1):
			
			arbol_animacion.set_mezcla_saltar_caer(i * 0.1)