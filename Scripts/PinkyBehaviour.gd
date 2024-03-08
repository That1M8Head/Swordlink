extends CharacterBody2D

var speed = 100.0
var player: Node2D
var player_hbox: Node2D
var anims: AnimatedSprite2D
var health: int = 100
@onready var attack_raycast = $AttackRaycast
@onready var flip_raycast = $FlipRaycast
@onready var proximity_raycast = $ProximityRaycast

var total_time = 0.4
var current_time = 0.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var knockback: Vector2

func _ready():
	anims = $AnimatedSprite2D
	anims.play("idle")

	player = get_node("/root/Game/Joel")
	player_hbox = get_node("/root/Game/Joel/Hurtbox")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if proximity_raycast.is_colliding() and (proximity_raycast.get_collider() == player or proximity_raycast.get_collider() == player_hbox):
		anims.play("attack")
	elif attack_raycast.is_colliding() and (attack_raycast.get_collider() == player or attack_raycast.get_collider() == player_hbox):
		anims.play("running")
		velocity.x = -speed
	elif flip_raycast.is_colliding() and (flip_raycast.get_collider() == player or attack_raycast.get_collider() == player_hbox):
		anims.play("running")
		velocity.x = speed
	else:
		velocity.x = 0
		anims.play("idle")
		
	if proximity_raycast.is_colliding() and anims.animation == "attack":
		current_time += delta
		if current_time > total_time:
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
	anims.stop()
	anims.play("idle")
	$DamageNumber.text = str(-damage_amount)
	$DamageNumber/AnimationPlayer.play("display_then_fade_out")
	knockback += knockback_v
	await(get_tree().create_timer(3).timeout)
	health -= damage_amount
	if health <= 0:
		die()

func die():
	queue_free()
