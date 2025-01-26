extends Button

signal tweet_received(id:int,result)
signal tweet_sent(idNum: int,text: String)

@export var player: CharacterBody2D
@export var tweetText: TextEdit
@export var API: Node
var idNum = 0

var bubblesSent: bool = false

func _on_pressed() -> void:
	var tweet = tweetText.text
	sendTweet(tweet)

func sendTweet(tweet):
	var bubbles = player.bubbles.keys()
	var id = idNum
	idNum +=1
	tweet_sent.emit(id,tweet)
	var result
	
	if bubblesSent:
		result = await API.get_similarity_async(tweet)
		tweet_received.emit(id,result)
		print("Tweet done")
	else:
		result = await API.get_similarity_async(tweet,bubbles)
		tweet_received.emit(id,result)
		bubblesSent= true
		print("Tweet done")

	var followers: int = player.followers*(tweet.length()/140+result[0].value)
	for sim in result.slice(1):
		print(sim.bubble," ",sim.value)
		if sim.value > 0.3:
			followers += sim.value*player.followers*0.5
			print("followers: ",(sim.value*followers)," ",tweet.length()," ",100)
	player.followers += followers
	
