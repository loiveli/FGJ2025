extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_add_tweet(text):
	var tweet = load("res://tweet_container.tscn").instance()
	tweet.initTweet(text)
	add_child(tweet)


