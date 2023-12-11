extends Area



func _on_Pinchos_body_entered(body: Node) -> void:
	
	var player : Godotin = body
	player.respawn()
