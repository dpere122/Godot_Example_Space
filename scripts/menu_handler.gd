extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event)->void:
	if(event.is_action_pressed("ui_console")):
		toggle_pause()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_resume_pressed():
	toggle_pause()
	

func _on_options_pressed():
	get_node("MainMenu").hide()
	get_node("Options").show()


func _on_exit_to_starhub_pressed():
	pass # Replace with function body.


func _on_button_pressed():
	pass # Replace with function body.


func toggle_pause() -> void:
	if(!get_tree().paused):
		show()
		get_node("MainMenu").show()
		get_node("Options").hide()
		get_tree().paused = true
		print(get_tree().paused)
	else:
		hide()
		get_node("MainMenu").hide()
		get_node("Options").hide()
		get_tree().paused = false
		print(get_tree().paused)
