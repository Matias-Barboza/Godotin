extends NinePatchRect

onready var animation_player = $AnimationPlayer

func activar_animacion():
	animation_player.play("enfriamiento")
