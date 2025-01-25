extends Button

signal tweet_received(result)

@export var tweetText: TextEdit
@export var API: Node




func _on_pressed() -> void:
	var tweet = tweetText.text
	print(tweet)
	var result = await API.get_similarity_async(tweet)
	var direction = Vector2(result[0].value,result[1].value)
	tweet_received.emit(direction)
	print("Tweet done")
	
