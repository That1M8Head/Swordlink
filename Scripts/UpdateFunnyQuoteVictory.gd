extends Label

@onready var difficulty = get_node("/root/DifficultyHandling")

func _ready():
	var quotes = [
		"Unfortunately, we don't have a ranking system yet.",
		"Good job, you did it!",
		"That was very epic",
		"See you next demo!",
		"Now do a speedrun.",
	]
	if difficulty.level == difficulty.DIFFICULTY.FRAMECAPPED:
		quotes.append("Now try bumping up the difficulty!")
	if get_node("/root/DifficultyHandling").level == difficulty.DIFFICULTY.OVERCLOCKED:
		quotes.append("Now do it again on Glitchfall difficulty.")
	text = quotes[randi_range(0, len(quotes) - 1)]

