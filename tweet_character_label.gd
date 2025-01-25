extends Label
@export var tweetEdit: TextEdit


func _ready():
	text = str(len(tweetEdit.text)) + "/140"

func _on_tweet_edit_text_changed() -> void:
	text = str(len(tweetEdit.text)) + "/140"
