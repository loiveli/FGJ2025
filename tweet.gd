extends Button

signal tweet_received(text:String,result)
signal tweet_sent(text: String)

@export var player: CharacterBody2D
@export var tweetText: TextEdit
@export var API: Node

var bubblesSent: bool = false

func _on_pressed() -> void:
	var tweet = tweetText.text
	sendTweet(tweet)

func sendTweet(tweet):
	var bubbles = player.bubbles.keys()
	tweet_sent.emit(tweet)
	if bubblesSent:
		var result = await API.get_similarity_async(tweet)
		tweet_received.emit(tweet,result)
		print("Tweet done")
	else:
		var result = await API.get_similarity_async(tweet,bubbles)
		tweet_received.emit(tweet,result)
		bubblesSent= true
		print("Tweet done")
