extends Control


export (String, FILE, "*.tscn") var menu_inicio = ""


onready var boton_pantalla_completa = $ContenedorTabulador/AudioVideo/PanelPrincipal/ContenedorPrincipal/PantallaCompleta
onready var opcion_resoluciones = $ContenedorTabulador/AudioVideo/PanelPrincipal/ContenedorPrincipal/Resolucion/OpcionResolucion
onready var resoluciones : Dictionary = {
	"640 x 480" : Vector2(640, 480),
	"960 x 640" : Vector2(960, 640),
	"1280 x 720" : Vector2(1280, 720),
	"1366 x 768" : Vector2(1366, 768),
	"1600 x 900" : Vector2(1600, 900),
	"1920 x 1080" : Vector2(1920, 1080)
}
onready var bus_indices := {
	"Master" : AudioServer.get_bus_index("Master"),
	"Musica" : AudioServer.get_bus_index("Musica"),
	"SFX" : AudioServer.get_bus_index("SFX")
}
onready var bus_etiquetas := {
	"Master" : $ContenedorTabulador/AudioVideo/PanelPrincipal/ContenedorPrincipal/VolumenGeneral/NivelVolumen,
	"Musica" : $ContenedorTabulador/AudioVideo/PanelPrincipal/ContenedorPrincipal/VolumenMusica/NivelVolumen,
	"SFX" : $ContenedorTabulador/AudioVideo/PanelPrincipal/ContenedorPrincipal/VolumenSFX/NivelVolumen
}


func _ready() -> void:
	
	boton_pantalla_completa.set_pressed(OS.window_fullscreen)
	cargar_resoluciones()
	chequear_resolucion_actual()
	cargar_volumen_buses()


func cargar_resoluciones() -> void:
	
	for resolucion in resoluciones.keys():
		
		opcion_resoluciones.add_item(resolucion)


func _on_RegresarButton_pressed() -> void:
	
	var guardar : GuardarCargar = GuardarCargar.new()
	guardar.guardar_datos_configuracion()
	get_tree().change_scene(menu_inicio)


func _on_PantallaCompleta_toggled(button_pressed: bool) -> void:
	
	OS.window_fullscreen = button_pressed


func _on_OpcionResolucion_item_selected(index: int) -> void:
	
	var nueva_resolucion : Vector2 = resoluciones[opcion_resoluciones.get_item_text(index)]
	
	OS.window_size = nueva_resolucion
	centrar_pantalla(OS.window_size)


func centrar_pantalla(resolucion : Vector2) -> void:
	
	var tamanio_pantalla := OS.get_screen_size()
	
	OS.set_window_position((tamanio_pantalla - resolucion) * 0.5)


func chequear_resolucion_actual() -> void:
	
	var texto_resolucion_actual = String(OS.window_size.x) + " x " + String(OS.window_size.y)
	var indice_resolucion_seleccionado : int = 0
	
	
	for i in range(opcion_resoluciones.get_item_count()):
		
		if texto_resolucion_actual == opcion_resoluciones.get_item_text(i):
			
			opcion_resoluciones.select(i)
			indice_resolucion_seleccionado = i


func cargar_volumen_buses() -> void:
	
	for bus_indice in bus_indices.values():
		
		var volumen_actual : float = AudioServer.get_bus_volume_db(bus_indice)
		var nombre_bus : String = AudioServer.get_bus_name(bus_indice)
		var texto_volumen : String = "%01d" % (volumen_actual + 50)
		bus_etiquetas[nombre_bus].text = texto_volumen


func cambiar_volumen(indice_bus : int, subir : bool) -> void:
	
	var volumen_anterior : float = AudioServer.get_bus_volume_db(indice_bus)
	var nuevo_volumen: float
	
	
	if subir:
		nuevo_volumen = volumen_anterior + 1
	else:
		nuevo_volumen = volumen_anterior - 1
	
	
	nuevo_volumen = clamp(nuevo_volumen, -50, 150)
	AudioServer.set_bus_volume_db(indice_bus, nuevo_volumen)
	
	if nuevo_volumen == -50 and indice_bus == bus_indices.Master:
		
		AudioServer.set_bus_mute(bus_indices.Musica, true)
		AudioServer.set_bus_mute(bus_indices.SFX, true)
	elif nuevo_volumen > -50 and indice_bus == bus_indices.Master:
		
		AudioServer.set_bus_mute(bus_indices.Musica, false)
		AudioServer.set_bus_mute(bus_indices.SFX, false)
	
	cargar_volumen_buses()


func _on_SubirVolumenGeneral_pressed() -> void:
	
	cambiar_volumen(bus_indices.Master, true)


func _on_BajarVolumenGeneral_pressed() -> void:
	
	cambiar_volumen(bus_indices.Master, false)


func _on_SubirVolumenMusica_pressed() -> void:
	
	cambiar_volumen(bus_indices.Musica, true)


func _on_BajarVolumenMusica_pressed() -> void:
	
	cambiar_volumen(bus_indices.Musica, false)


func _on_SubirVolumenSFX_pressed() -> void:
	
	cambiar_volumen(bus_indices.SFX, true)


func _on_BajarVolumenSFX_pressed() -> void:
	
	cambiar_volumen(bus_indices.SFX, false)
