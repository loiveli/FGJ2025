extends ScrollContainer

func _process(delta):
    if self.get_v_scroll_bar().value < self.get_v_scroll_bar().max_value:
        self.get_v_scroll_bar().set_value_no_signal(self.get_v_scroll_bar().value+1)
