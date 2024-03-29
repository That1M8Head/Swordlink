extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -500.0
const DECELERATION = 1300.0

var enemy_count: int = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var health: int
var sword_position: Vector2

enum StyleRank {
	None,
	F,
	E,
	D,
	C,
	B,
	A,
	S,
}
var style_rank: int
var style_duration: float

@onready var hitbox = $SlashHitbox
@onready var hitbox_left = $SlashHitbox2

var dashing = false

func _ready():
	update_sword_position()
	health = 100
	style_rank = StyleRank.None
	var style_rank_meter = get_node("/root/Game/CanvasLayer/HUD/Style/Meter")
	style_rank_meter.value = 0
	
func get_rank_name() -> Array:
	var rank_letter: String
	var rank_name: String
	var rank_colour: Color
	match style_rank:
		StyleRank.S:
			rank_letter = "S"
			rank_name = "Stylish Skills"
			rank_colour = "#1E8EFF"
		StyleRank.A:
			rank_letter = "A"
			rank_name = "Actually Good"
			rank_colour = "#3CAFFF"
		StyleRank.B:
			rank_letter = "B"
			rank_name = "Better Now"
			rank_colour = "#63B3FF"
		StyleRank.C:
			rank_letter = "C"
			rank_name = "Cool Combos"
			rank_colour = "#8AC9FF"
		StyleRank.D:
			rank_letter = "D"
			rank_name = "Dull Damage"
			rank_colour = "#B2D0FF"
		StyleRank.E:
			rank_letter = "E"
			rank_name = "Extra Lame"
			rank_colour = "#D9E7FF"
		StyleRank.F:
			rank_letter = "F"
			rank_name = "Frick Off"
			rank_colour = "#FFFFFF"
		_:
			rank_letter = "W"
			rank_name = "What the Frick"
			rank_colour = "Crimson"
	return [rank_letter, rank_name, rank_colour]

func update_sword_position():
	var base_sword_position_left = Vector2(14, -9);
	var base_sword_position_right = Vector2(-14, -9);

	if velocity.x < 0:
		$JoelSprite.flip_h = true
		$JoelSprite/Sword.flip_h = true
		sword_position = base_sword_position_right
	elif velocity.x > 0:
		$JoelSprite.flip_h = false
		$JoelSprite/Sword.flip_h = false
		sword_position = base_sword_position_left
	elif not $JoelSprite.flip_h:
		$JoelSprite/Sword.flip_h = false
		sword_position = base_sword_position_left

func _process(delta):
	var health_bar = get_node("/root/Game/CanvasLayer/HUD/HealthBar")
	var health_tween = get_node("/root/Game/CanvasLayer/HUD/Tween").create_tween()
	health_tween.tween_property(health_bar, "value", health, 0.1)
	var style_rank_display = get_node("/root/Game/CanvasLayer/HUD/Style/Rank/Letter")
	var style_rank_name = get_node("/root/Game/CanvasLayer/HUD/Style/Rank/Name")
	var style_rank_meter = get_node("/root/Game/CanvasLayer/HUD/Style/Meter")
	var style_rank_anim = get_node("/root/Game/CanvasLayer/HUD/Style/Rank/AnimationPlayer")
	var style_tween = get_node("/root/Game/CanvasLayer/HUD/Tween").create_tween()
	style_tween.tween_property(style_rank_meter, "value", style_duration, 0.05)
	style_rank_display.text = get_rank_name()[0]
	style_rank_name.text = get_rank_name()[1]
	style_rank_display.label_settings.font_color = get_rank_name()[2]
	style_rank_name.label_settings.font_color = get_rank_name()[2]
	if style_rank == StyleRank.None:
		style_rank_display.modulate = "#00000000"
		style_rank_name.modulate = "#00000000"
	else:
		style_rank_display.modulate = "#FFFFFFFF"
		style_rank_name.modulate = "#FFFFFFFF"
	if style_rank_meter.value == 0:
		style_rank_meter.modulate = "#00000000"
	else:
		style_rank_meter.modulate = "#FFFFFFFF"
	if style_rank >= StyleRank.S:
		style_duration = clamp(style_duration, 0, style_rank_meter.max_value)
	if style_duration >= style_rank_meter.max_value and style_rank < StyleRank.S:
		style_duration = 500
		style_rank += 1
		style_rank_anim.stop()
		style_rank_anim.play("fade_in")
	style_duration -= 2 * (style_rank + 1)
	if style_duration <= 0 and style_rank > StyleRank.None:
		style_duration = style_rank_meter.max_value - 1
		style_rank -= 1
	health = clamp(health, 0, health_bar.max_value)
	style_duration = clamp(style_duration, -1, style_rank_meter.max_value)
	enemy_count = get_tree().get_nodes_in_group("Enemy").size()
	if enemy_count < 1:
		get_tree().change_scene_to_file("res://victory.tscn")
	if health_bar.value <= 0:
		get_tree().change_scene_to_file("res://death_screen.tscn")

func _physics_process(delta):
	var sword_animation: AnimationPlayer = $JoelSprite/Sword/SwordAnim
	var mode_shift = Input.is_action_pressed("ModeShift")
	
	var move_speed = SPEED / 2 if mode_shift else SPEED
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	var stinger = sword_animation.current_animation.contains("stinger")
	var updraft = sword_animation.current_animation.contains("updraft")

	if Input.is_action_just_pressed("Jump") and is_on_floor() and not updraft:
		$JumpSound.play()
		velocity.y = JUMP_VELOCITY

	var blocking_attack = stinger or updraft
	if not blocking_attack:
		var direction = Input.get_axis("MoveLeft", "MoveRight")
		if not dashing and Input.is_action_just_pressed("Evade"):
			do_evasion()
		if direction and not dashing:
			if is_on_floor():
				velocity.x = direction * move_speed
			else:
				velocity.x += direction * move_speed * delta * 4
			velocity.x = clamp(velocity.x, -move_speed, move_speed)
		elif is_on_floor():
			velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)

		if Input.is_action_just_pressed("Attack"):
			if mode_shift:
				# Stinger
				if Input.is_action_pressed("MoveLeft") and $JoelSprite.flip_h == true:
					stinger_attack(true)
				elif Input.is_action_pressed("MoveRight") and $JoelSprite.flip_h == false:
					stinger_attack(false)
				# Updraft
				elif is_on_floor():
					if Input.is_action_pressed("MoveLeft") and $JoelSprite.flip_h == false:
						updraft_attack(true)
					elif Input.is_action_pressed("MoveRight") and $JoelSprite.flip_h == true:
						updraft_attack(false)
					else:
						do_directed_sword_slash()
				# Downslash
				elif not is_on_floor():
					if Input.is_action_pressed("MoveLeft") and $JoelSprite.flip_h == false:
						downslash_attack(true)
					elif Input.is_action_pressed("MoveRight") and $JoelSprite.flip_h == true:
						downslash_attack(false)
					else:
						do_directed_sword_slash()
				else:
					do_directed_sword_slash()
			else:
				do_directed_sword_slash()
					
		if Input.is_action_just_pressed("AltAttack") and direction:
			stinger_attack($JoelSprite.flip_h)
		elif Input.is_action_just_pressed("AltAttack") and is_on_floor():
			updraft_attack(!$JoelSprite.flip_h)
		elif Input.is_action_just_pressed("AltAttack") and not is_on_floor():
			downslash_attack(!$JoelSprite.flip_h)

	if not mode_shift:
		update_sword_position()

	$JoelSprite/Sword.position = sword_position

	move_and_slide()
	
	if dashing:
		reset_evasion_flags()


func direction_facing(sprite: AnimatedSprite2D) -> int:
	if sprite.flip_h:
		return -1
	else:
		return 1

func do_evasion():
	var direction = Input.get_axis("MoveLeft", "MoveRight")
	direction = direction_facing($JoelSprite) if direction == 0 else direction
	var move_speed = direction * SPEED * 3 if is_on_floor() else direction * SPEED * 1.8
	dashing = true
	modulate = Color(1, 1, 1, 0.5)
	$DodgeSound.play()
	set_collision_mask_value(2, false)
	velocity.x = move_speed

func reset_evasion_flags():
	await(get_tree().create_timer(0.3).timeout)
	set_collision_mask_value(2, true)
	modulate = "#ffffffff"
	dashing = false
	move_and_slide()
	
func do_directed_sword_slash():
	if $JoelSprite.flip_h:
		do_sword_slash(true)
	else:
		do_sword_slash(false)

func do_sword_slash(left: bool):
	var sword_animation: AnimationPlayer = $JoelSprite/Sword/SwordAnim
	sword_animation.stop()
	$SwordSound.play()
	if left:
		sword_animation.play("sword_slash_left")
		hitbox_left.monitoring = true
	else:
		sword_animation.play("sword_slash")
		hitbox.monitoring = true
	await(get_tree().create_timer(0.2).timeout)
	hitbox.monitoring = false
	hitbox_left.monitoring = false

func stinger_attack(flipped: bool):
	$JoelSprite/Sword/SwordAnim.stop()
	$StingerSound.play()
	if flipped:
		velocity.x = -(SPEED * 2)
		$StingerHitbox2.monitoring = true
		$JoelSprite/Sword/SwordAnim.play("stinger_left")
	else:
		velocity.x = SPEED * 2
		$StingerHitbox.monitoring = true
		$JoelSprite/Sword/SwordAnim.play("stinger")
	await(get_tree().create_timer(0.3).timeout)
	$StingerHitbox.monitoring = false
	$StingerHitbox2.monitoring = false

func updraft_attack(flipped: bool):
	$JoelSprite/Sword/SwordAnim.stop()
	$UpdraftSound.play()
	if flipped:
		$JoelSprite/Sword/SwordAnim.play("updraft")
	else:
		$JoelSprite/Sword/SwordAnim.play("updraft_left")
	await(get_tree().create_timer(0.12).timeout)
	velocity.x = 0
	if Input.is_action_pressed("Attack") or Input.is_action_pressed("AltAttack"):
		velocity.y += JUMP_VELOCITY * 1.1
	if flipped:
		$UpdraftHitbox2.monitoring = true
	else:
		$UpdraftHitbox.monitoring = true
	move_and_slide()
	await(get_tree().create_timer(0.1).timeout)
	$UpdraftHitbox.monitoring = false
	$UpdraftHitbox2.monitoring = false

func downslash_attack(flipped: bool):
	$JoelSprite/Sword/SwordAnim.stop()
	$UpdraftSound.play()
	if flipped:
		$JoelSprite/Sword/SwordAnim.play("sword_slash")
	else:
		$JoelSprite/Sword/SwordAnim.play("sword_slash_left")
	await(get_tree().create_timer(0.12).timeout)
	velocity.x = 0
	velocity.y -= JUMP_VELOCITY * 2
	$DownslashHitbox.monitoring = true
	move_and_slide()
	await(get_tree().create_timer(0.4).timeout)
	$DownslashHitbox.monitoring = false
	await(get_tree().create_timer(0.6).timeout)

func _on_slash_hitbox_body_entered(body):
	if body.has_method("take_damage"):
		var damage = randi_range(10, 25)
		if not is_on_floor():
			damage *= 1.5
		deal_damage(body, damage, Vector2(damage * 15, 0))

func _on_stinger_hitbox_body_entered(body):
	if body.has_method("take_damage"):
		var damage = randi_range(40, 55)
		if not is_on_floor():
			damage *= 1.5
		deal_damage(body, damage, Vector2(damage * 15, damage * 5))

func _on_updraft_hitbox_body_entered(body):
	if body.has_method("take_damage"):
		var damage = randi_range(5, 15)
		if not is_on_floor():
			damage *= 1.5
		deal_damage(body, damage, Vector2(damage * 5, JUMP_VELOCITY * 0.8))

func _on_downslash_hitbox_body_entered(body):
	if body.has_method("take_damage"):
		var damage = randi_range(45, 60)
		deal_damage(body, damage, Vector2(0, -JUMP_VELOCITY))

func deal_damage(body, damage: int, knockback: Vector2):
	$HitSound.play()
	var difficulty_handler = get_node("/root/DifficultyHandling")
	if damage > body.health and difficulty_handler.level < 3:
		var health_reward = damage / 6
		health += health_reward * (style_rank + 1)
	style_duration += damage * 48 if not body.is_on_floor() else damage * 19
	var flip = -1 if $JoelSprite.flip_h else 1
	body.take_damage(damage, Vector2(knockback.x * flip, knockback.y))

func damage_self(amount: int):
	if dashing:
		return
	health -= amount
	var style_rank_meter = get_node("/root/Game/CanvasLayer/HUD/Style/Meter")
	style_duration -= style_rank_meter.max_value / 3

func _on_off_stage_body_entered(body):
	call_deferred("error_message")

func error_message():
	get_tree().change_scene_to_file("res://guru_meditation.tscn")
