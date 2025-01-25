extends VBoxContainer
var tweet = preload("res://tweet_container.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_add_tweet(text):
	var newTweet = tweet.instantiate()
	newTweet.initTweet(text)
	add_child(newTweet)

func _on_update_tweet(tweetText, result):
	var tweetObject = get_children().filter(func(node):return node.text==tweetText)
	tweetObject.updateStats(result[0].value * randi_range(100,1000),result[1].value * randi_range(100,1000))
