extends CharacterBody2D

var speed = 100.0
var player: Node2D
var player_hbox: Node2D
var anims: AnimatedSprite2D
var health: int = 100

@onready var difficulty_handler = get_node("/root/DifficultyHandling")

@onready var attack_raycast = $AttackRaycast
@onready var flip_raycast = $FlipRaycast
@onready var proximity_raycast = $ProximityRaycast

var total_time = 0.3
var current_time = 0.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var knockback: Vector2

func _ready():
	match difficulty_handler.level:
		0:
			speed = 100.0
			total_time = 0.5
		1:
			speed = 200.0
			total_time = 0.3
		2:
			speed = 400.0
			total_time = 0.2
		3:
			speed = 400.0
			total_time = 0.2

	anims = $AnimatedSprite2D
	anims.play("idle")

	player = get_node("/root/Game/Joel")
	player_hbox = get_node("/root/Game/Joel/Hurtbox")
	
func _process(delta):
	$HealthBar.value = health

func _physics_process(delta):
	if health <= 0:
		return

	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor():
		if proximity_raycast.is_colliding() and (proximity_raycast.get_collider() == player or proximity_raycast.get_collider() == player_hbox):
			anims.play("attack")
		elif attack_raycast.is_colliding() and (attack_raycast.get_collider() == player or attack_raycast.get_collider() == player_hbox):
			if anims.animation == "idle":
				$SeeSound.play()
			anims.play("running")
			velocity.x = -speed
		elif flip_raycast.is_colliding() and (flip_raycast.get_collider() == player or attack_raycast.get_collider() == player_hbox):
			if anims.animation == "idle":
				$SeeSound.play()
			anims.play("running")
			velocity.x = speed
		else:
			velocity.x = 0
			anims.play("idle")
	else:
		anims.play("idle")
		
	if (proximity_raycast.is_colliding() or flip_raycast.is_colliding()) and anims.animation == "attack":
		current_time += delta
		if current_time > total_time:
			$AttackSound.play()
			player.damage_self(randi_range(5, 15))
			current_time = 0

	var original_tpos_attack = attack_raycast.target_position
	var original_tpos_flip = flip_raycast.target_position
		
	if flip_raycast.is_colliding() and flip_raycast.get_collider() == player:
		$AnimatedSprite2D.flip_h = true
		proximity_raycast.target_position.x = 50
	else:
		$AnimatedSprite2D.flip_h = false
		proximity_raycast.target_position.x = -50
		
	if knockback.x != 0 or knockback.y != 0:
		velocity = knockback
		move_and_slide()
		await(get_tree().create_timer(0.2).timeout)
		knockback = Vector2(0, 0)

	move_and_slide()
	
func take_damage(damage_amount: int, knockback_v: Vector2):
	$DamageNumber/AnimationPlayer.stop()
	$HealthBar/AnimationPlayer.stop()
	anims.stop()
	anims.play("idle")
	$DamageNumber.text = str(-damage_amount)
	$DamageNumber/AnimationPlayer.play("display_then_fade_out")
	$HealthBar/AnimationPlayer.play("display_then_fade_out")
	health -= damage_amount
	knockback += knockback_v
	if health <= 0:
		die()

func die():
	set_collision_layer_value(2, false)
	$DeathAnim.play("death")
	$DeathSound.play()
	await($DeathAnim.animation_finished)
	queue_free()
