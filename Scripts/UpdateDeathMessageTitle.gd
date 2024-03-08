extends Label

func _ready():
	var titles = [
		"You Are Die",
		"You died!", # Minecraft reference
		"Try Again", # Sonic Frontiers reference
		"Game Over",
		"Git Gud",
		"Very F***ing Deceased", # Reelism 2 reference
		"You are ded!", # Team Fortress 2 reference
		"You are not alive",
		"You died lol.", # Final Fantasy Sonic X5/X6 reference, I forgot which one tho
		"How many times have you died?", # Team Fortress 2 reference
		"Well, that was lame.", # Sonic Unleashed reference
		"You Are Lose", # GradeAUnderA reference
		"A winner is you(!)", # Henry Stickmin reference, specifically Infiltrating The Airship
		"An attempt was made",
		"𝐦Ꚛ𝐑†𝐈𝐒", # mortis, FAITH: The Unholy Trinity reference
	]
	text = titles[randi_range(0, len(titles) - 1)]
