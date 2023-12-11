extends Control
tool


export (String, FILE, "*.tscn") var nivel_inicial = ""
export (String, FILE, "*.tscn") var menu_ajustes = ""
export (String, FILE, "*.tscn") var pantalla_carga = ""


func _ready() -> void:
	
	var cargar : GuardarCargar = GuardarCargar.new()
	
	var archivo_carga = File.new()
	
	if archivo_carga.file_exists(cargar.seleccionar_ruta(GuardarCargar.JUEGO)):
		cargar.cargar_datos_juego()
		
		$ContenedorPrincipal/CargarButton.disabled = false


func _on_SalirButton_pressed() -> void:
	
	get_tree().quit()


func _on_OpcionesButton_pressed() -> void:
	
	$SFXboton.play()
	yield(get_tree().create_timer(0.1), "timeout")
	get_tree().change_scene(menu_ajustes)


func _get_configuration_warning() -> String:
	
	if menu_ajustes == "":
		
		return "Chequear rutas"
	
	return ""


func _on_NuevoButton_pressed() -> void:
	
	DatosJuego.nivel_actual = nivel_inicial
	get_tree().change_scene(pantalla_carga)


func _on_CargarButton_pressed() -> void:
	
	get_tree().change_scene(DatosJuego.nivel_actual)
