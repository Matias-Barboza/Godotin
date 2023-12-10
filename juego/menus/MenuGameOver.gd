extends Control


func _on_ReintentarNivelButton_pressed() -> void:
	
	get_tree().change_scene(DatosJuego.nivel_actual)
