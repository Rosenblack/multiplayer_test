extends CharacterBody3D

@export var speed = 6
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO
@onready var cam = $Models/Camera3D
var n = 0
var model = 0

func _ready() -> void:
	cam.current = is_multiplayer_authority()
	$Models/Pivot/AnimationPlayer.speed_scale = 2
	$gui/NameSelect/Button.hide()
	$gui/NameSelect/LineEdit.hide()
	$gui/ModelSelect/BaseChange.hide()
	$gui/ModelSelect/ShaleChange.hide()
	if is_multiplayer_authority():
		# MAKE SURE THIS SHIT STAYS HIDDEN IN EDITOR OR IT BREAKS #
		$gui/NameSelect/Button.show()
		$gui/NameSelect/LineEdit.show()
		$gui/ModelSelect/BaseChange.show()
		$gui/ModelSelect/ShaleChange.show()
	
func _process(delta: float) -> void:
	if is_multiplayer_authority():
		if model == 0:
			$Models/Pivot/Base.show()
			$Models/Pivot/Shale.hide()
		if model == 1:
			$Models/Pivot/Base.hide()
			$Models/Pivot/Shale.show()
	
func _physics_process(delta):
	if is_multiplayer_authority():
		if n == 1:
			if Input.is_action_just_pressed("quit"):
				$"../".exit_game(name.to_int())
				get_tree().quit()
				
			var direction = Vector3.ZERO

			if Input.is_action_pressed("move_right"):
				direction.x += 1
			if Input.is_action_pressed("move_left"):
				direction.x -= 1
			if Input.is_action_pressed("move_backward"):
				direction.z += 1
			if Input.is_action_pressed("move_forward"):
				direction.z -= 1

			if direction != Vector3.ZERO:
				direction = direction.normalized()
				$Models/Pivot.basis = Basis.looking_at(direction)
				if model == 0:
					$Models/Pivot/AnimationPlayer.play("base_walk")
				if model == 1:
					$Models/Pivot/AnimationPlayer.play("shale_walk")
			if direction == Vector3.ZERO:
				if model == 0:
					$Models/Pivot/AnimationPlayer.play("base_idle")
				if model == 1:
					$Models/Pivot/AnimationPlayer.play("shale_idle")

			# Ground Velocity
			target_velocity.x = direction.x * speed
			target_velocity.z = direction.z * speed

		# Vertical Velocity
		if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
			target_velocity.y = target_velocity.y - (fall_acceleration * delta)
			pass

		# Moving the Character
		velocity = target_velocity
		move_and_slide()
	
func _enter_tree():
	set_multiplayer_authority(name.to_int())


func _on_button_pressed() -> void:
	if is_multiplayer_authority():
		$gui/NameSelect/Button.hide()
		$gui/NameSelect/LineEdit.hide()
		$gui/ModelSelect/BaseChange.hide()
		$gui/ModelSelect/ShaleChange.hide()
		$Models/Pivot/Label3D.text = $gui/NameSelect/LineEdit.text
		$Models/Pivot/Label3D2.text = $gui/NameSelectBig/LineEdit.text
		$gui/NameSelectBig.hide()
		$gui/ModelSelectBig.hide()
		n = 1

func _on_base_change_pressed() -> void:
		model = 0

func _on_shale_change_pressed() -> void:
		model = 1

func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		$gui/NameSelect/Button.hide()
		$gui/NameSelect/LineEdit.hide()
		$gui/ModelSelect/BaseChange.hide()
		$gui/ModelSelect/ShaleChange.hide()
		$gui/Controls.hide()
		$gui/ControlsBig.show()
		if !n == 1:
			$gui/NameSelectBig.show()
			$gui/ModelSelectBig.show()
	if toggled_on == false:
		if !n == 1:
			$gui/NameSelect/Button.show()
			$gui/NameSelect/LineEdit.show()
			$gui/ModelSelect/BaseChange.show()
			$gui/ModelSelect/ShaleChange.show()
		$gui/Controls.show()
		$gui/ControlsBig.hide()
		$gui/NameSelectBig.hide()
		$gui/ModelSelectBig.hide()
