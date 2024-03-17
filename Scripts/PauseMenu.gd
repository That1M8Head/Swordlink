extends Panel

func _process(delta):
	if not visible:
		return
	if Input.is_action_just_pressed("MenuBack"):
		visible = false

func _on_visibility_changed():
	if visible:
		for node in get_tree().get_nodes_in_group("Pausable"):
			node.set_process_input(false)
			node.set_physics_process(false)
	else:
		await(get_tree().create_timer(0.5).timeout)
		for node in get_tree().get_nodes_in_group("Pausable"):
			node.set_process_input(true)
			node.set_physics_process(true)
