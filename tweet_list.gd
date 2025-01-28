extends VBoxContainer
var tweet = preload("res://tweet_container.tscn")
# Called when the node enters the scene tree for the first time.
@export var player: CharacterBody2D

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_add_tweet(id,text):
	print()
	var newTweet = tweet.instantiate()
	newTweet.initTweet(id,text)
	add_child(newTweet)

func _on_update_tweet(id,text, result):
	var tweetObject = get_children().filter(func(node):return node.tweetID == id)[0]
	var followers = 0
	for sim in result:
		if sim.value > 0.3 and sim.value > result[0].value/2:
			followers += player.followers*(tweetObject.tweetText.length()/140+sim.value)*0.25
	print(followers, " Followers gained")
	tweetObject.updateStats(result[0].value * randi_range(player.followers/2,player.followers),result[1].value * randi_range(player.followers/2,player.followers),followers)
