extends Control


export (String) var title = ""
export (String) var confirm_text = ""
export (String) var cancel_text = ""

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal confirm_pressed
signal cancel_pressed




# Called when the node enters the scene tree for the first time.
func _ready():
	$Title.text = title
	$Confirm.text = confirm_text
	$Cancel.text = cancel_text
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	

func _on_Confirm_pressed():
	emit_signal("confirm_pressed")

func _on_Cancel_pressed():
	emit_signal("cancel_pressed")
