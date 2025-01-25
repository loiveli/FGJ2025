extends Button

signal tweet_recieved(result)

@export var tweetText: TextEdit
@export var API: Node




func _on_pressed() -> void:
	var tweet = tweetText.text
	var result = await API.get_similarity_async(tweet)
	tweet_recieved.emit(result)
	print("Tweet done: "+ result)
