extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("#"+$"..".topic)
	text = "#"+$"..".topic

func updateText(tweetText, hasTweets = false):
	if hasTweets:
		text = tweetText+" #"+$"..".topic
	else:
		text = "#"+$"..".topic
