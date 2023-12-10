extends Control


onready var titulo = $Titulo
onready var puntos = $Puntos


func _ready() -> void:
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	titulo.text = "Nivel {num} completo".format({"num": DatosJuego.num_nivel_actual})
	puntos.text = "{puntos}\nPuntos totales".format({"puntos" : DatosJuego.generar_puntaje()})


func _on_SiguienteNivelButton_pressed() -> void:
	
	get_tree().change_scene(DatosJuego.nivel_proximo)
