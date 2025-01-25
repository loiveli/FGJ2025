extends Button

signal tweet_received(result)

@export var tweetText: TextEdit
@export var API: Node




func _on_pressed() -> void:
	var tweet = tweetText.text
	print(tweet)
	var result = await API.get_similarity_async(tweet)
	tweet_received.emit(result)
	print("Tweet done")
	
