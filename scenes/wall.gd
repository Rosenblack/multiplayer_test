extends StaticBody3D

func _ready() -> void:
	if !(Engine.is_editor_hint()):
		$MeshInstance3D.hide()
