extends Control


func _ready() -> void:
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)



func _on_ReintentarNivelButton_pressed() -> void:
	
	DatosJuego.reset()
	get_tree().change_scene(DatosJuego.nivel_actual)
