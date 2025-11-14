extends CharacterBody3D

@export var speed = 6
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO
@onready var cam = $Camera3D
var n = 0

func _ready() -> void:
	cam.current = is_multiplayer_authority()
	$Pivot/AnimationPlayer.speed_scale = 2
	if is_multiplayer_authority():
		$Control/LineEdit.show()
		$Control/Button.show()
		$Control/LineEdit.placeholder_text = "choose name"
		$Label3D.text = "player"
	
func _process(delta: float) -> void:
	pass
	
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
				$Pivot.basis = Basis.looking_at(direction)
				$Pivot/AnimationPlayer.play("animation_walk")
			if direction == Vector3.ZERO:
				$Pivot/AnimationPlayer.play("animation_idle")

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
		$Label3D.text = $Control/LineEdit.text
		n = 1
		$Control/LineEdit.hide()
		$Control/Button.hide()
