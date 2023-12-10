extends Node
tool

export var numero_nivel : int = 0
export (String, FILE, "*.tscn") var proximo_nivel = ""
export (String, FILE, "*.tscn") var menu_game_over = ""


func _ready() -> void:
	
	yield(get_tree().create_timer(0.4),"timeout")
	actualizar_datos()


func actualizar_datos() -> void:
	
	DatosJuego.nivel_actual = get_tree().current_scene.filename
	DatosJuego.num_nivel_actual = numero_nivel
	DatosJuego.nivel_proximo = proximo_nivel
	Eventos.connect("game_over", self, "game_over")


func game_over() -> void:
	
	get_tree().change_scene(menu_game_over)


func _get_configuration_warning() -> String:
	
	if numero_nivel == 0 or proximo_nivel == "":
		return "Chequear valores de nivel"
	
	return ""
