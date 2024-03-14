extends Label

func _ready():
	var titles = [
		"Victory!",
		"""You're 
Winner !""",
		"Mission Clear",
		"Mission Complete",
		"You did a thing!",
	]
	text = titles[randi_range(0, len(titles) - 1)]
