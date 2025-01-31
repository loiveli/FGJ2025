extends Button

signal tweet_received(idNum:int,text:String,result)
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
	var bubbles = player.bubbles.values().map(func (bubbleNode): return bubbleNode.topic)
	var id = idNum
	idNum +=1
	tweet_sent.emit(id,tweet)
	var result
	
	if bubblesSent:
		result = await API.get_similarity_async(tweet)
		tweet_received.emit(id,text,result)
		print("Tweet done")
	else:
		result = await API.get_similarity_async(tweet,bubbles)
		tweet_received.emit(id,text,result)
		bubblesSent= true
		print("Tweet done")

	var followers: int = 0
	for sim in result:
		print(sim.bubble," ",sim.value)
		if sim.value > 0.3 and sim.value > result[0].value/2:
			var newFollowers = player.followers*(tweet.length()/140+sim.value)*0.5
			followers += newFollowers
			
	player.followers += followers
	
