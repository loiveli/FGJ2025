extends VBoxContainer

@export var tweetTextLabel: Label
@export var tweetLikesLabel: Label
@export var tweetRetweetLabel: Label
@export var tweetFollowersLabel: Label

var tweetText: String
var tweetLikes: int
var tweetRetweets: int
var reach: float = 0.1
var tweetID: int
var tweetFollowers: int
var reachMult: float = 0.01

func updateTweet(delta):
	if reach <1:
		reach +=reachMult
		reachMult *= 1+delta
	tweetLikesLabel.text = str(int(tweetLikes*reach))
	tweetRetweetLabel.text = str(int(tweetRetweets*reach))
	tweetFollowersLabel.text = str(int(tweetFollowers*reach))


func _process(delta):
	updateTweet(delta)

func updateStats(likes: int, retweets: int,followers: int):
	tweetLikes += likes
	tweetRetweets += retweets
	tweetFollowers += followers

func initTweet(idNum,text: String,likes: int = randi_range(0,10 ), retweets: int = randi_range(0,10 )):
	tweetID = idNum
	tweetTextLabel.text = text
	tweetLikes = likes
	tweetRetweets= retweets
	tweetFollowers = 0
