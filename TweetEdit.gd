extends TextEdit


# Called when the node enters the scene tree for the first time.
@export var LIMIT: int = 140
var current_text = ''
var cursor_line = 0
var cursor_column = 0


func _on_text_changed() -> void:
	var new_text: String = self.text
	if new_text.length() > LIMIT:
		self.text = current_text
		# when replacing the text, the cursor will get moved to the beginning of the
		# text, so move it back to where it was 
		self.set_caret_line(cursor_line)
		self.set_caret_column(cursor_column)

	current_text = self.text
	# save current position of cursor for when we have reached the limit
	cursor_line = self.get_caret_line()
	cursor_column = self.get_caret_column()


func _on_tweet_button_tweet_sent(text: String) -> void:
	clear()
