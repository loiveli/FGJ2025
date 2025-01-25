extends VBoxContainer

@export var tweetText: Label
@export var tweetLikes: Label
@export var tweetRetweet: Label




func initTweet(text: String,likes: int = randi_range(0,1000 ), retweets: int = randi_range(0,1000 )):
	tweetText.text = text
	tweetLikes.text = str(likes)
	tweetRetweet.text = str(retweets)
