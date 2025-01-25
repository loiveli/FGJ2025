extends TextEdit


# Called when the node enters the scene tree for the first time.
@export var LIMIT: int = 140
var current_text = ''
var cursor_line = 0
var cursor_column = 0
@export var tweetButton: Button

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

func _input(event: InputEvent) -> void:
	if self.has_focus():
		if event is InputEventWithModifiers and event is InputEventKey and event.is_pressed():
			if event.keycode == KEY_ENTER and !event.shift_pressed:
				print(typeof(event))
				tweetButton.sendTweet(text)
				get_viewport().set_input_as_handled()
				
			elif event.keycode == KEY_ENTER:
				insert_text_at_caret(("\n"))
				get_viewport().set_input_as_handled()
				

func _on_tweet_button_tweet_sent(idNum,text: String) -> void:
	clear()
