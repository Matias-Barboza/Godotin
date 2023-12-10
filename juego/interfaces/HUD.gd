extends Control


onready var contenedor_vidas = $ContenedorVidas/Cantidad
onready var etiqueta_monedas_oro = $ContenedorMonedasOro/Cantidad


func _ready():
# warning-ignore:return_value_discarded
	Eventos.connect("actualizar_hud", self, "actualizar_hud")
	actualizar_hud()


func actualizar_hud():
	contenedor_vidas.text = "%s" % DatosJuego.vidas
	etiqueta_monedas_oro.text = "%s" % DatosJuego.monedas_oro
